import argparse
import sys

parser = argparse.ArgumentParser(
        prog='Compute Pointer Transformations')
parser.add_argument("-g", "--general", action="store_true")
parser.add_argument("-n", "--nondestructive", action="store_true")

args = parser.parse_args()

nodes = []
edges = {}

# Populate nodes of the graph
for base in ["ghost", "Box", "Rc", "shared", "mut"]:
    for array in [True, False]:
        for cell in [True, False]:
            node = (base, array, cell)
            nodes.append(node)
            edges[node] = set()

if args.general:
    # Base type transformations
    for array in [True, False]:
        for cell in [True, False]:
            edges[("ghost", array, cell)].add(("Box", array, cell))
            edges[("ghost", array, cell)].add(("mut", array, cell))
            edges[("Box", array, cell)].add(("ghost", array, cell))
            edges[("Box", array, cell)].add(("Rc", array, cell))
            edges[("mut", array, cell)].add(("mut", array, cell))
            edges[("mut", array, cell)].add(("shared", array, cell))
            edges[("Rc", array, cell)].add(("Rc", array, cell))
            edges[("Rc", array, cell)].add(("shared", array, cell))
            edges[("shared", array, cell)].add(("shared", array, cell))

    # Array decay transformations
    for base in ["ghost", "Box", "shared", "mut"]:
        for cell in [True, False]:
            edges[(base, True, cell)].add((base, False, cell))

    # Cell transformations
    edges[("shared"), False, True].add(("mut", False, False))
    for base in ["ghost", "Box"]:
        for array in [True, False]:
            edges[(base, array, True)].add((base, array, False))
            edges[(base, array, False)].add((base, array, True))

elif args.nondestructive:
    # Base type transformations
    for array in [True, False]:
        for cell in [True, False]:
            edges[("ghost", array, cell)].add(("mut", array, cell))
            edges[("Box", array, cell)].add(("mut", array, cell))
            edges[("mut", array, cell)].add(("mut", array, cell))
            edges[("mut", array, cell)].add(("shared", array, cell))
            edges[("Rc", array, cell)].add(("Rc", array, cell))
            edges[("Rc", array, cell)].add(("shared", array, cell))
            edges[("shared", array, cell)].add(("shared", array, cell))

    # Array decay transformations
    for base in ["shared", "mut"]:
        for cell in [True, False]:
            edges[(base, True, cell)].add((base, False, cell))

    # Cell transformations
    edges[("shared"), False, True].add(("mut", False, False))

else:
    print("Need to specify the type of pointer transformation.", file=sys.stderr)
    print("Use one of: `--general`, `--nondestructive`", file=sys.stderr)
    exit(1)

# Compute reachable set
def dfs(origin):
    visited = set()
    q = list(edges[origin])
    while q:
        n = q.pop()
        visited.add(n)
        for m in edges[n]:
            if m not in visited:
                q.append(m)
    return visited

reachable = { n: dfs(n) for n in nodes }

def fmt_bool(b):
    if b:
        return "true"
    else:
        return "false"

def fmt_tuple(n):
    return "(\"" + n[0] + "\", " + fmt_bool(n[1]) + ", " + fmt_bool(n[2]) + ")"

for (s, R) in reachable.items():
    print(f"{fmt_tuple(s)} => phf_set! {{")
    for t in R:
        print(f"    {fmt_tuple(t)},")
    print(f"}},")
