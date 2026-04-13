use std::{cell::Cell, rc::Rc};

pub struct RBTree {
    root: Rc<Node>,
    nil: Rc<Node>,
}

#[derive(Default)]
pub struct Node {
    color: Cell<i32>,
    key: Cell<i32>,
    parent: Cell<Option<Rc<Node>>>,
    left: Cell<Option<Rc<Node>>>,
    right: Cell<Option<Rc<Node>>>,
}

pub const RBTREE_BLACK: i32 = 0;
pub const RBTREE_RED: i32 = 1;

/// Clones the interior value of a `Cell<T>`.
///
/// This translation generally uses this to clone an `Rc` pointer inside of
/// a `Cell`.
fn get_cloned<T: Clone + Default>(src: &Cell<T>) -> T {
    let r = src.take();
    src.set(r.clone());
    r
}

pub fn new_rbtree() -> RBTree {
    let nil_node = Rc::new(Node {
        color: Cell::new(RBTREE_BLACK),
        key: Cell::new(i32::default()),
        parent: Cell::new(None),
        left: Cell::new(None),
        right: Cell::new(None),
    });
    RBTree {
        root: Rc::clone(&nil_node),
        nil: Rc::clone(&nil_node),
    }
}

pub fn right_rotation(tree: &mut RBTree, x: Rc<Node>) {
    // TODO!
    // 1. target의 left으로 y 설정
    let y = get_cloned(&x.left).unwrap();
    // 2. y의 오른쪽 서브트리를 target의 왼쪽 서브트리로 옮김
    x.left.set(get_cloned(&y.right));
    // 3. y의 오른쪽 노드가 NIL이 아니라면, y의 오른쪽 노드 부모를 target으로 설정
    if std::ptr::addr_eq(&*get_cloned(&y.right).unwrap(), &*tree.nil) {
        get_cloned(&y.right)
            .unwrap()
            .parent
            .set(Some(Rc::clone(&x)));
    }
    // 4. y의 부모 노드를 target의 부모 노드로 설정
    y.parent.set(get_cloned(&x.parent));
    // 5. target의 부모 노드가 nil이라면, 트리 구조체의 root를 y로 설정
    if std::ptr::addr_eq(&*get_cloned(&x.parent).unwrap(), &*tree.nil) {
        tree.root = Rc::clone(&y);
    }
    // 6. target이 target 부모 노드의 왼쪽이면, target 부모의 왼쪽을 y로 설정
    else if std::ptr::addr_eq(
        &*x,
        &*get_cloned(&get_cloned(&x.parent).unwrap().left).unwrap(),
    ) {
        get_cloned(&x.parent).unwrap().left.set(Some(Rc::clone(&y)));
    }
    // 7. target이 target 부모 노드의 오른쪽이면, target 부모의 오른쪽을 y로 설정
    else {
        get_cloned(&x.parent)
            .unwrap()
            .right
            .set(Some(Rc::clone(&y)));
    }
    // 8. target을 y의 오른쪽으로 설정
    y.right.set(Some(Rc::clone(&x)));
    // 9. target의 부모를 y로 설정
    x.parent.set(Some(y));
}

pub fn left_rotation(tree: &mut RBTree, x: Rc<Node>) {
    // TODO!
    let y = get_cloned(&x.right).unwrap();
    x.right.set(get_cloned(&y.left));
    if std::ptr::addr_eq(&*get_cloned(&y.left).unwrap(), &*tree.nil) {
        get_cloned(&y.left).unwrap().parent.set(Some(Rc::clone(&x)));
    }
    y.parent.set(get_cloned(&x.parent));
    if std::ptr::addr_eq(&*get_cloned(&x.parent).unwrap(), &*tree.nil) {
        tree.root = Rc::clone(&y);
    } else if std::ptr::addr_eq(
        &*x,
        &*get_cloned(&get_cloned(&x.parent).unwrap().left).unwrap(),
    ) {
        get_cloned(&x.parent).unwrap().left.set(Some(Rc::clone(&y)));
    } else {
        get_cloned(&x.parent)
            .unwrap()
            .right
            .set(Some(Rc::clone(&y)));
    }
    y.left.set(Some(Rc::clone(&x)));
    x.parent.set(Some(y));
}

pub fn rbtree_insert_fixup(t: &mut RBTree, mut z: Rc<Node>) {
    while get_cloned(&z.parent).unwrap().color.get() == RBTREE_RED {
        // z의 부모가 조부모의 왼쪽 서브 트리일 경우
        if std::ptr::addr_eq(
            &*get_cloned(&z.parent).unwrap(),
            &*get_cloned(
                &get_cloned(&get_cloned(&z.parent).unwrap().parent)
                    .unwrap()
                    .left,
            )
            .unwrap(),
        ) {
            let y = get_cloned(
                &get_cloned(&get_cloned(&z.parent).unwrap().parent)
                    .unwrap()
                    .right,
            )
            .unwrap();

            // CASE 1 : 노드 z의 삼촌 y가 적색인 경우
            if y.color.get() == RBTREE_RED {
                get_cloned(&z.parent).unwrap().color.set(RBTREE_BLACK);
                y.color.set(RBTREE_BLACK);
                get_cloned(
                    &get_cloned(&get_cloned(&z.parent).unwrap().parent)
                        .unwrap()
                        .parent,
                )
                .unwrap()
                .color
                .set(RBTREE_RED);
                z = get_cloned(&get_cloned(&z.parent).unwrap().parent).unwrap();
            }
            // CASE 2 : z의 삼촌 y가 흑색이며의 z가 오른쪽 자식인 경우
            else {
                if std::ptr::addr_eq(
                    &*z,
                    &*get_cloned(&get_cloned(&z.parent).unwrap().right).unwrap(),
                ) {
                    z = get_cloned(&z.parent).unwrap();
                    left_rotation(t, Rc::clone(&z));
                }
                // CASE 3 : z의 삼촌 y가 흑색이며의 z가 오른쪽 자식인 경우
                get_cloned(&z.parent).unwrap().color.set(RBTREE_BLACK);
                get_cloned(&get_cloned(&z.parent).unwrap().parent)
                    .unwrap()
                    .color
                    .set(RBTREE_RED);
                right_rotation(
                    t,
                    get_cloned(&get_cloned(&z.parent).unwrap().parent).unwrap(),
                );
            }
        }
        // z의 부모가 조부모의 왼쪽 서브 트리일 경우
        else {
            let y = get_cloned(
                &get_cloned(&get_cloned(&z.parent).unwrap().parent)
                    .unwrap()
                    .left,
            )
            .unwrap();
            // CASE 4 : 노드 z의 삼촌 y가 적색인 경우
            if y.color.get() == RBTREE_RED {
                get_cloned(&z.parent).unwrap().color.set(RBTREE_BLACK);
                y.color.set(RBTREE_BLACK);
                get_cloned(
                    &get_cloned(&get_cloned(&z.parent).unwrap().parent)
                        .unwrap()
                        .parent,
                )
                .unwrap()
                .color
                .set(RBTREE_RED);
                z = get_cloned(&get_cloned(&z.parent).unwrap().parent).unwrap();
            }
            // CASE 5 : z의 삼촌 y가 흑색이며의 z가 오른쪽 자식인 경우
            else {
                if std::ptr::addr_eq(
                    &*z,
                    &*get_cloned(&get_cloned(&z.parent).unwrap().left).unwrap(),
                ) {
                    z = get_cloned(&z.parent).unwrap();
                    right_rotation(t, Rc::clone(&z));
                }
                // CASE 6 : z의 삼촌 y가 흑색이며의 z가 오른쪽 자식인 경우
                get_cloned(&z.parent).unwrap().color.set(RBTREE_BLACK);
                get_cloned(&get_cloned(&z.parent).unwrap().parent)
                    .unwrap()
                    .color
                    .set(RBTREE_RED);
                left_rotation(
                    t,
                    get_cloned(&get_cloned(&z.parent).unwrap().parent).unwrap(),
                );
            }
        }
    }
}

pub fn rbtree_insert(t: &mut RBTree, key: i32) -> Rc<Node> {
    // TODO: implement insert
    let mut y = Rc::clone(&t.nil);
    let mut x = Rc::clone(&t.nil);
    let z = Rc::new(Node::default());

    z.key.set(key);

    while !std::ptr::addr_eq(&*x, &*t.nil) {
        y = Rc::clone(&x);
        if z.key.get() < x.key.get() {
            x = get_cloned(&x.left).unwrap();
        } else {
            x = get_cloned(&x.right).unwrap();
        }
    }

    z.parent.set(Some(Rc::clone(&y)));

    if std::ptr::addr_eq(&*y, &*t.nil) {
        t.root = Rc::clone(&z);
    } else if z.key.get() < y.key.get() {
        y.left.set(Some(Rc::clone(&z)));
    } else {
        y.right.set(Some(Rc::clone(&z)));
    }

    z.left.set(Some(Rc::clone(&t.nil)));
    z.right.set(Some(Rc::clone(&t.nil)));
    z.color.set(RBTREE_RED);

    rbtree_insert_fixup(t, Rc::clone(&z));

    z
}

pub fn rbtree_find(t: &RBTree, key: i32) -> Option<Rc<Node>> {
    // TODO: implement find
    let mut current = Rc::clone(&t.root);
    while !std::ptr::addr_eq(&*current, &*t.nil) {
        if current.key.get() == key {
            return Some(current);
        }
        if current.key.get() < key {
            current = get_cloned(&current.right).unwrap();
        } else {
            current = get_cloned(&current.left).unwrap();
        }
    }
    None
}

pub fn rbtree_min(t: &RBTree) -> Option<Rc<Node>> {
    // TODO: implement find
    if std::ptr::addr_eq(&*t.root, &*t.nil) {
        return None;
    }

    let mut curr = Rc::clone(&t.root);

    while !std::ptr::addr_eq(&*get_cloned(&curr.left).unwrap(), &*t.nil) {
        curr = get_cloned(&curr.left).unwrap();
    }
    Some(curr)
}

pub fn rbtree_max(t: &RBTree) -> Option<Rc<Node>> {
    // TODO: implement find
    if std::ptr::addr_eq(&*t.root, &*t.nil) {
        return None;
    }

    let mut curr = Rc::clone(&t.root);

    while !std::ptr::addr_eq(&*get_cloned(&curr.right).unwrap(), &*t.nil) {
        curr = get_cloned(&curr.right).unwrap();
    }
    Some(curr)
}

pub fn rbtree_transplant(t: &mut RBTree, u: &Node, v: Rc<Node>) {
    if std::ptr::addr_eq(&*get_cloned(&u.parent).unwrap(), &*t.nil) {
        t.root = Rc::clone(&v);
    } else if std::ptr::addr_eq(
        u,
        &*get_cloned(&get_cloned(&u.parent).unwrap().left).unwrap(),
    ) {
        get_cloned(&u.parent).unwrap().left.set(Some(Rc::clone(&v)));
    } else {
        get_cloned(&u.parent)
            .unwrap()
            .right
            .set(Some(Rc::clone(&v)));
    }
    v.parent.set(get_cloned(&u.parent));
}

pub fn rbtree_delete_fixup(t: &mut RBTree, mut x: Rc<Node>) {
    while !std::ptr::addr_eq(&*x, &*t.root) && x.color.get() == RBTREE_BLACK {
        // CASE 1 ~ 4 : LEFT CASE
        if std::ptr::addr_eq(
            &*x,
            &*get_cloned(&get_cloned(&x.parent).unwrap().right).unwrap(),
        ) {
            let mut w = get_cloned(&get_cloned(&x.parent).unwrap().right).unwrap();

            // CASE 1 : x의 형제 w가 적색인 경우
            if w.color.get() == RBTREE_RED {
                w.color.set(RBTREE_BLACK);
                get_cloned(&w.parent).unwrap().color.set(RBTREE_RED);
                left_rotation(t, get_cloned(&x.parent).unwrap());
                w = get_cloned(&get_cloned(&x.parent).unwrap().right).unwrap();
            }

            // CASE 2 : x의 형제 w는 흑색이고 w의 두 지식이 모두 흑색인 경우
            if get_cloned(&w.left).unwrap().color.get() == RBTREE_BLACK
                && get_cloned(&w.right).unwrap().color.get() == RBTREE_BLACK
            {
                w.color.set(RBTREE_RED);
                x = get_cloned(&x.parent).unwrap();
            }
            // CASE 3 : x의 형제 w는 흑색, w의 왼쪽 자식은 적색, w의 오른쪽 자신은 흑색인 경우
            else {
                if get_cloned(&w.right).unwrap().color.get() == RBTREE_BLACK {
                    get_cloned(&w.left).unwrap().color.set(RBTREE_BLACK);
                    w.color.set(RBTREE_RED);
                    right_rotation(t, Rc::clone(&w));
                    w = get_cloned(&get_cloned(&x.parent).unwrap().right).unwrap();
                }

                // CASE 4 : x의 형제 w는 흑색이고 w의 오른쪽 자식은 적색인 경우
                w.color.set(get_cloned(&x.parent).unwrap().color.get());
                get_cloned(&w.parent).unwrap().color.set(RBTREE_BLACK);
                get_cloned(&w.right).unwrap().color.set(RBTREE_BLACK);
                left_rotation(t, get_cloned(&x.parent).unwrap());
                x = Rc::clone(&t.root);
            }
        }
        // CASE 5 ~ 8 : RIGHT CASE
        else {
            let mut w = get_cloned(&get_cloned(&x.parent).unwrap().left).unwrap();

            // CASE 5 : x의 형제 w가 적색인 경우
            if w.color.get() == RBTREE_RED {
                w.color.set(RBTREE_BLACK);
                get_cloned(&x.parent).unwrap().color.set(RBTREE_RED);
                right_rotation(t, get_cloned(&x.parent).unwrap());
                w = get_cloned(&get_cloned(&x.parent).unwrap().left).unwrap();
            }

            // CASE 6 : x의 형제 w는 흑색이고 w의 두 지식이 모두 흑색인 경우
            if get_cloned(&w.right).unwrap().color.get() == RBTREE_BLACK
                && get_cloned(&w.left).unwrap().color.get() == RBTREE_BLACK
            {
                w.color.set(RBTREE_RED);
                x = get_cloned(&x.parent).unwrap();
            }
            // CASE 7 : x의 형제 w는 흑색, w의 왼쪽 자식은 적색, w의 오른쪽 자신은 흑색인 경우
            else {
                if get_cloned(&w.left).unwrap().color.get() == RBTREE_BLACK {
                    get_cloned(&w.right)
                        .unwrap()
                        .color
                        .set(get_cloned(&x.parent).unwrap().color.get());
                    w.color.set(RBTREE_RED);
                    left_rotation(t, Rc::clone(&w));
                    w = get_cloned(&get_cloned(&x.parent).unwrap().left).unwrap();
                }

                // CASE 8 : x의 형제 w는 흑색이고 w의 오른쪽 자식은 적색인 경우
                w.color.set(get_cloned(&x.parent).unwrap().color.get());
                get_cloned(&x.parent).unwrap().color.set(RBTREE_BLACK);
                get_cloned(&x.left).unwrap().color.set(RBTREE_BLACK);
                right_rotation(t, get_cloned(&x.parent).unwrap());
                x = Rc::clone(&t.root);
            }
        }
    }

    todo!()
}

pub fn rbtree_erase(t: &mut RBTree, p: &Node) -> i32 {
    // TODO: implement erase
    let x;
    let mut y_original_color = p.color.get();

    if std::ptr::addr_eq(&*get_cloned(&p.left).unwrap(), &*t.nil) {
        x = get_cloned(&p.right).unwrap();
        rbtree_transplant(t, p, get_cloned(&p.right).unwrap());
    } else if std::ptr::addr_eq(&*get_cloned(&p.right).unwrap(), &*t.nil) {
        x = get_cloned(&p.left).unwrap();
        rbtree_transplant(t, p, get_cloned(&p.left).unwrap());
    } else {
        let mut y = get_cloned(&p.right).unwrap();
        while !std::ptr::addr_eq(&*get_cloned(&y.left).unwrap(), &*t.nil) {
            y = get_cloned(&y.left).unwrap();
        }
        y_original_color = y.color.get();
        x = get_cloned(&y.right).unwrap();

        if std::ptr::addr_eq(&*get_cloned(&y.parent).unwrap(), p) {
            x.parent.set(Some(Rc::clone(&y)));
        } else {
            rbtree_transplant(t, &y, get_cloned(&y.right).unwrap());
            y.right.set(get_cloned(&p.right));
            get_cloned(&y.right)
                .unwrap()
                .parent
                .set(Some(Rc::clone(&y)));
        }

        rbtree_transplant(t, p, Rc::clone(&y));
        y.left.set(get_cloned(&p.left));
        get_cloned(&y.left).unwrap().parent.set(Some(Rc::clone(&y)));
        y.color.set(p.color.get());
    }

    if y_original_color == RBTREE_BLACK {
        rbtree_delete_fixup(t, x);
    }

    0
}

/// Tests from CRUST-Bench, adapted to the translated interface.
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_init() {
        let t = new_rbtree();
        assert!(std::ptr::addr_eq(&*t.root, &*t.nil));
    }

    #[test]
    fn test_insert_single() {
        let mut t = new_rbtree();
        let key: i32 = 1024;
        let p = rbtree_insert(&mut t, key);

        assert_eq!(t.root.key.get(), key);
        assert_eq!(p.key.get(), key);
        assert!(std::ptr::addr_eq(&*get_cloned(&p.left).unwrap(), &*t.nil));
        assert!(std::ptr::addr_eq(&*get_cloned(&p.right).unwrap(), &*t.nil));
        assert!(std::ptr::addr_eq(&*get_cloned(&p.parent).unwrap(), &*t.nil));
    }

    #[test]
    fn test_find_single() {
        let mut t = new_rbtree();
        let key: i32 = 512;
        let wrong_key: i32 = 1024;

        let p = rbtree_insert(&mut t, key);
        let q = rbtree_find(&t, key);
        assert!(q.is_some());
        assert_eq!(q.clone().unwrap().key.get(), key);
        assert_eq!(
            q.clone().unwrap().key.get(),
            p.key.get(),
        );

        let q = rbtree_find(&t, wrong_key);
        assert!(q.is_none());
    }

    #[test]
    fn test_erase_root() {
        let mut t = new_rbtree();
        let key: i32 = 128;
        let p = rbtree_insert(&mut t, key);
        assert_eq!(t.root.key.get(), key);

        rbtree_erase(&mut t, &p);
        assert!(std::ptr::addr_eq(&*t.root, &*t.nil));
    }
}
