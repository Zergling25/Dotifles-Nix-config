import os
from xml.etree.ElementTree import Element, SubElement, ElementTree

# File paths
todo_txt_path = os.path.expanduser("~/To-Do.txt")
todo_xml_path = os.path.expanduser("~/.config/waybar/Scripts/todo.xml")

def generate_todo_menu():
    interface = Element("interface")
    menu = SubElement(interface, "object", {"class": "GtkMenu", "id": "menu"})

    # Separator
    sep1 = SubElement(menu, "child")
    SubElement(sep1, "object", {"class": "GtkSeparatorMenuItem", "id": "delimiter1"})

    # ✏️ Edit To-Do
    edit_child = SubElement(menu, "child")
    edit_item = SubElement(edit_child, "object", {"class": "GtkMenuItem", "id": "edit_todo"})
    edit_label = SubElement(edit_item, "property", {"name": "label"})
    edit_label.text = "✏️ Edit To-Do"

    # Separator
    sep2 = SubElement(menu, "child")
    SubElement(sep2, "object", {"class": "GtkSeparatorMenuItem", "id": "delimiter2"})

    # 📝 Tasks
    if os.path.exists(todo_txt_path):
        with open(todo_txt_path, "r") as f:
            lines = [line.strip() for line in f if line.strip()]
    else:
        lines = ["No tasks found."]

    for i, task in enumerate(lines):
        child = SubElement(menu, "child")
        item = SubElement(child, "object", {"class": "GtkMenuItem", "id": f"task_{i}"})
        label = SubElement(item, "property", {"name": "label"})
        label.text = task

    # Write XML
    tree = ElementTree(interface)
    tree.write(todo_xml_path, encoding="UTF-8", xml_declaration=True)

generate_todo_menu()

