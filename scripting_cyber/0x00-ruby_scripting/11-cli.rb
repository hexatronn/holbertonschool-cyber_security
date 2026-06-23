#!/usr/bin/env ruby

require 'optparse'

TASKS_FILE = 'tasks.txt'

def load_tasks
  return [] unless File.exist?(TASKS_FILE)
  File.readlines(TASKS_FILE).map(&:chomp)
end

def save_tasks(tasks)
  File.write(TASKS_FILE, tasks.join("\n") + (tasks.empty? ? '' : "\n"))
end

def add_task(task)
  tasks = load_tasks
  tasks << task
  save_tasks(tasks)
  puts "Task '#{task}' added."
end

def list_tasks
  tasks = load_tasks
  if tasks.empty?
    puts 'No tasks found.'
  else
    puts 'Tasks:'
    tasks.each_with_index { |task, i| puts "#{i + 1}. #{task}" }
  end
end

def remove_task(index)
  tasks = load_tasks
  i = index.to_i - 1
  if i < 0 || i >= tasks.length
    puts "Invalid index: #{index}"
  else
    removed = tasks.delete_at(i)
    save_tasks(tasks)
    puts "Task '#{removed}' removed."
  end
end

options = {}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: cli.rb [options]'

  opts.on('-a', '--add TASK', 'Add a new task') do |task|
    options[:add] = task
  end

  opts.on('-l', '--list', 'List all tasks') do
    options[:list] = true
  end

  opts.on('-r', '--remove INDEX', 'Remove a task by index') do |index|
    options[:remove] = index
  end

  opts.on('-h', '--help', 'Show help') do
    puts opts
    exit
  end
end

parser.parse!

if options[:add]
  add_task(options[:add])
elsif options[:list]
  list_tasks
elsif options[:remove]
  remove_task(options[:remove])
else
  puts parser
end
