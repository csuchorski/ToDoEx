defmodule ToDoList do
  def start() do
    filename = IO.gets("Input file name: ") |> String.trim()
    read_file(filename)
    # show_help()
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

  def show_tasks() do
    # Lists all tasks
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
        c ->create new task\n
        d ->delete existing task
        l ->list all existing tasks
        s ->save tasks to a file
        h ->show all commands
        ")
    get_command()
  end

  def get_command() do
    command = IO.gets("Input command: ") |> String.trim()

    case command do
      "c" ->
        create_task()

      "d" ->
        delete_task()

      "l" ->
        show_tasks()

      "u" ->
        update_task()

      "s" ->
        save_tasks()

      "h" ->
        show_help()

      _ ->
        IO.puts("Please input correct command.\n")
        show_help()
        get_command()
    end
  end
end
