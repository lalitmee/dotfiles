#!/usr/bin/env node

const fs = require("fs/promises");
const path = require("path");

const TODO_DIR = path.join(process.cwd(), ".gemini", "todos");

const TOOL_DEFINITIONS = [
  {
    "name": "create_todo_list",
    "description": "Creates a new todo list for a task.",
    "parameters": {
      "type": "OBJECT",
      "properties": {
        "task_name": {
          "type": "STRING",
          "description": "The name of the task."
        },
        "todo_items": {
          "type": "ARRAY",
          "items": {
            "type": "STRING"
          },
          "description": "The initial list of todo items."
        }
      },
      "required": ["task_name", "todo_items"]
    }
  },
  {
    "name": "update_todo_item",
    "description": "Updates the status of a todo item.",
    "parameters": {
      "type": "OBJECT",
      "properties": {
        "task_name": {
          "type": "STRING",
          "description": "The name of the task."
        },
        "item_index": {
          "type": "NUMBER",
          "description": "The index of the todo item to update."
        },
        "is_checked": {
          "type": "BOOLEAN",
          "description": "The new checked status of the todo item."
        }
      },
      "required": ["task_name", "item_index", "is_checked"]
    }
  },
  {
    "name": "delete_todo_list",
    "description": "Deletes the todo list for a completed task.",
    "parameters": {
      "type": "OBJECT",
      "properties": {
        "task_name": {
          "type": "STRING",
          "description": "The name of the task."
        }
      },
      "required": ["task_name"]
    }
  },
  {
    "name": "list_todo_lists",
    "description": "Lists all existing todo lists.",
    "parameters": { "type": "OBJECT", "properties": {} }
  }
];

async function getTodoState(taskName) {
  try {
    await fs.mkdir(TODO_DIR, { recursive: true });
    const todoFilePath = path.join(TODO_DIR, `${taskName}.json`);
    const content = await fs.readFile(todoFilePath, "utf-8");
    return JSON.parse(content);
  } catch (error) {
    if (error.code === "ENOENT") {
      return { tasks: [], active_task_index: null };
    }
    throw error;
  }
}

async function setTodoState(taskName, state) {
  await fs.mkdir(TODO_DIR, { recursive: true });
  const todoFilePath = path.join(TODO_DIR, `${taskName}.json`);
  await fs.writeFile(todoFilePath, JSON.stringify(state, null, 2));
}

async function createTodoList(params) {
  const { task_name, todo_items } = params;
  const state = {
    tasks: todo_items.map(text => ({ text, is_complete: false })),
    active_task_index: null,
  };
  await setTodoState(task_name, state);
  console.log(JSON.stringify({ success: true }));
}

async function updateTodoItem(params) {
  const { task_name, item_index, is_checked } = params;
  const state = await getTodoState(task_name);
  const task = state.tasks[item_index];
  if (!task) {
    throw new Error(`Task with index ${item_index} not found.`);
  }
  task.is_complete = is_checked;
  await setTodoState(task_name, state);
  console.log(JSON.stringify({ success: true }));
}

async function deleteTodoList(params) {
  const { task_name } = params;
  const todoFilePath = path.join(TODO_DIR, `${task_name}.json`);
  try {
    await fs.unlink(todoFilePath);
    console.log(JSON.stringify({ success: true }));
  } catch (error) {
    if (error.code === "ENOENT") {
      throw new Error(`Todo list for task '${task_name}' not found.`);
    }
    throw error;
  }
}

async function listTodoLists() {
  try {
    const files = await fs.readdir(TODO_DIR);
    const taskNames = files.map(file => file.replace(".json", ""));
    console.log(JSON.stringify(taskNames));
  } catch (error) {
    if (error.code === "ENOENT") {
      console.log(JSON.stringify([]));
      return;
    }
    throw error;
  }
}

function readStdin() {
  return new Promise((resolve) => {
    let data = "";
    process.stdin.on("data", (chunk) => {
      data += chunk;
    });
    process.stdin.on("end", () => {
      resolve(JSON.parse(data || "{}"));
    });
  });
}

async function main() {
  if (process.argv[2] === "discover") {
    console.log(JSON.stringify(TOOL_DEFINITIONS, null, 2));
    return;
  }

  const toolName = process.argv[2];
  const toolParams = await readStdin();

  switch (toolName) {
    case "create_todo_list":
      await createTodoList(toolParams);
      break;
    case "update_todo_item":
      await updateTodoItem(toolParams);
      break;
    case "delete_todo_list":
      await deleteTodoList(toolParams);
      break;
    case "list_todo_lists":
      await listTodoLists();
      break;
    default:
      console.error(`Unknown tool: ${toolName}.`);
      process.exit(1);
  }
}

main().catch((error) => {
  console.error("Tool execution failed:", error.message);
  process.exit(1);
});
