#!/usr/bin/env bash

FUNCTION_NAME=$1
PARAMS=$2

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
TODOS_DIR="$SCRIPT_DIR/../../todos"

create_todo_list() {
  TASK_NAME=$(echo $PARAMS | jq -r '.task_name')
  TODO_ITEMS=$(echo $PARAMS | jq -r '.todo_items')

  TODO_FILE="$TODOS_DIR/$TASK_NAME.json"

  if [ -f "$TODO_FILE" ]; then
    echo "{\"error\": \"Todo list for task '$TASK_NAME' already exists.\"}"
    exit 1
  fi

  echo "[]" | jq --argjson items "$TODO_ITEMS" \
    '. | . * $items | map({text: ., checked: false})' > "$TODO_FILE"

  echo "{\"success\": true}"
}

update_todo_item() {
  TASK_NAME=$(echo $PARAMS | jq -r '.task_name')
  ITEM_INDEX=$(echo $PARAMS | jq -r '.item_index')
  IS_CHECKED=$(echo $PARAMS | jq -r '.is_checked')

  TODO_FILE="$TODOS_DIR/$TASK_NAME.json"

  if [ ! -f "$TODO_FILE" ]; then
    echo "{\"error\": \"Todo list for task '$TASK_NAME' not found.\"}"
    exit 1
  fi

  jq --argjson index "$ITEM_INDEX" --argjson checked "$IS_CHECKED" \
    '.[$index].checked = $checked' "$TODO_FILE" > "$TODO_FILE.tmp" && mv "$TODO_FILE.tmp" "$TODO_FILE"

  echo "{\"success\": true}"
}

delete_todo_list() {
  TASK_NAME=$(echo $PARAMS | jq -r '.task_name')

  TODO_FILE="$TODOS_DIR/$TASK_NAME.json"

  if [ ! -f "$TODO_FILE" ]; then
    echo "{\"error\": \"Todo list for task '$TASK_NAME' not found.\"}"
    exit 1
  fi

  read -p "Are you sure you want to delete the todo list for task '$TASK_NAME'? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm "$TODO_FILE"
    echo "{\"success\": true}"
  else
    echo "{\"success\": false, \"message\": \"Deletion cancelled.\"}"
  fi
}

list_todo_lists() {
  ls -1 "$TODOS_DIR" | sed 's/\.json$//'
}

case $FUNCTION_NAME in
  "create_todo_list")
    create_todo_list
    ;;
  "update_todo_item")
    update_todo_item
    ;;
  "delete_todo_list")
    delete_todo_list
    ;;
  "list_todo_lists")
    list_todo_lists
    ;;
  *)
    echo "{\"error\": \"Unknown function: $FUNCTION_NAME\"}"
    exit 1
    ;;
esac
