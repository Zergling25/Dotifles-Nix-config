import os, sys

todo_txt = os.path.expanduser("~/To-Do.txt")

def toggle_task(index):
    if not os.path.exists(todo_txt): return
    with open(todo_txt) as f:
        lines = [line.strip() for line in f if line.strip()]
    if index >= len(lines): return

    task = lines[index]
    if task.startswith("~~") and task.endswith("~~"):
        lines[index] = task[2:-2]
    else:
        lines[index] = f"~~{task}~~"

    with open(todo_txt, "w") as f:
        f.write("\n".join(lines) + "\n")

if __name__ == "__main__":
    if len(sys.argv) == 2:
        try: toggle_task(int(sys.argv[1]))
        except: pass

