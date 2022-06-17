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
  end

  def show_details(name, data) do
    if name in Map.keys(data) do
      IO.inspect(data[name])
    else
      IO.puts("Item not in the list")
    end
  end

  def create_task() do
    # Adds new tasks
  end

  def delete_task() do
    # Delete specific task
  end

  def update_task() do
    # Update specific task
  end

  def save_tasks() do
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
        create_task()
        get_command(data)

      "dt" ->
        name = IO.gets("Input name of task: ") |> String.trim()
        show_details(name, data)
        get_command(data)

      "del" ->
        delete_task()
        get_command(data)

      "ls" ->
        show_tasks(data)
        get_command(data)

      "u" ->
        update_task()
        get_command(data)

      "sv" ->
        save_tasks()
        get_command(data)

      "h" ->
        show_help()
        get_command(data)

      "q" ->
        {:ok, "App closed"}

      _ ->
        IO.puts("Please input correct command.\n")
        show_help()
        get_command(data)
    end
  end
end
