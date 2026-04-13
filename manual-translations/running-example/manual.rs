use std::cell::RefCell;
use std::rc::Rc;

struct Node {
  data: i32,
  next: Option<Rc<RefCell<Node>>>,
}
fn new() -> Node {
  Node { data: i32::default(), next: None }
}
fn push(list: &mut Node, x: i32) {
  let n = Rc::new(RefCell::new(Node {
    data: x,
    next: list.next.take(),
  }));
  list.next = Some(n);
}
fn replace(dst: &mut i32, x: i32) {
  *dst = x;
}
fn replace_first(list: &Node, x: i32) {
  replace(&mut list.next.as_ref().unwrap().borrow_mut().data, x);
}
fn first(list: &Node) -> i32 {
  list.next.as_ref().unwrap().borrow().data
}
fn main() {
  let mut list = new();
  push(&mut list, 1);
  let sublist = list.next.as_ref().unwrap();
  push(&mut sublist.borrow_mut(), 2);
  replace_first(&list, 3);
  replace_first(&sublist.borrow(), 4);
  //println!("{} {}", first(&list), first(&sublist.borrow()));
}
