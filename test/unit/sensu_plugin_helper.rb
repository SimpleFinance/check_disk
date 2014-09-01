require 'minitest/autorun'

module SensuPluginTestHelper
  def script(script)
    s = Pathname.new(script)
    @script = s.expand_path
  end

  def run_script(*args)
    IO.popen(([@script] + args).join(' '), 'r+') do |child|
      child.read
    end
  end

  def run_script_with_input(input, *args)
    IO.popen(([@script] + args).join(' '), 'r+') do |child|
      child.puts input
      child.close_write
      child.read
    end
  end
end
