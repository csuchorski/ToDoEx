defmodule ToDoList do
  def start() do
    filename = IO.gets("Input file name: ") |> String.trim()
    parsed_data = read_file(filename)
    show_help()
    get_command(parsed_data)
  end

  def read_file(filename) do
    # Opens a file
    case File.read(filename) do
      {:ok, content} ->
        parse_file(content |> String.replace_prefix("\uFEFF", ""))

      {:error, error} ->
        IO.puts("Error while loading file: #{error}")
    end
  end

  def parse_file(content) do
    [header | lines] = String.split(content, ~r(\r\n|\r|\n))
    titles = header |> String.split(",") |> tl
    parse_lines(titles, lines)
  end

  def parse_lines(titles, lines) do
    Enum.reduce(lines, %{}, fn line, result ->
      # Split name of todo and other fields
      [name | fields] = String.split(line, ",")
      # Check if line contains all needed data
      if Enum.count(titles) == Enum.count(fields) do
        # Make every todo into a separate map with titles as keys to fields
        fields_mapped = Enum.zip(titles, fields) |> Enum.into(%{})
        # Merge small maps into one big result map with names of todo as key
        Map.merge(result, %{name => fields_mapped})
      else
        # If it doesn't contain all needed fields -> skip the row
        result
      end
    end)
  end

  def show_tasks(data) do
    items = Map.keys(data)
    Enum.each(items, fn x -> IO.puts(x) end)

    get_command(data)
  end

  def show_details(name, data) do
    if name in Map.keys(data) do
      IO.inspect(data[name])
    else
      IO.puts("Item not in the list")
    end

    get_command(data)
  end

  def create_task(data) do
    name = IO.gets("Input name of task: ") |> String.trim()
    priority = IO.gets("Input task priority: ") |> String.trim()
    date = IO.gets("Input date: ") |> String.trim()
    notes = IO.gets("Input notes: ") |> String.trim()

    changed_data = Map.put_new(data, name, %{Priority: priority, Date: date, Notes: notes})
    get_command(changed_data)
  end

  def delete_task(data) do
    task_name =
      IO.gets("Input name of task you want to delete: ")
      |> String.trim()

    if Map.has_key?(data, task_name) do
      changed_data = Map.drop(data, [task_name])
      show_tasks(changed_data)
      get_command(changed_data)
    else
      IO.puts("Task doesn't exist")
      get_command(data)
    end
  end

  def update_task(data) do
    # Update specific task
  end

  def save_tasks(data) do
    # Save changes to the file
  end

  def show_help() do
    IO.puts(~S"Available commands:\n
        cr ->create new task\n
        dt ->show details of a task
        del ->delete existing task
        ls ->list all existing tasks
        u ->update existing task
        sv ->save tasks to a file
        h ->show all commands
        q ->exit app
        ")
  end

  def get_command(data) do
    command = IO.gets("Input command: ") |> String.trim()

    case command do
      "cr" ->
        create_task(data)

      "dt" ->
        name = IO.gets("Input name of task: ") |> String.trim()
        show_details(name, data)

      "del" ->
        delete_task(data)

      "ls" ->
        show_tasks(data)

      "u" ->
        update_task(data)

      "sv" ->
        save_tasks(data)

      "h" ->
        show_help()

      "q" ->
        {:ok, "App closed"}

      _ ->
        IO.puts("Please input correct command.\n")
        show_help()
        get_command(data)
    end
  end
end
