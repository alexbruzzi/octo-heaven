# Load all environment related things first
require 'god'
require 'dotenv'

ROOT = File.join(File.dirname(__FILE__)) unless defined? ROOT
Dotenv.load

$: << File.dirname(__FILE__)

#
# Email notification settings
#
God::Contacts::Email.defaults do |d|
  d.from_email = 'noreply-god@octo.ai'
  d.from_name = 'God'
  d.delivery_method = :sendmail
end

#
# Send email to following contacts
#
God.contact(:email) do |c|
  c.name = 'Octomatic API'
  c.to_email = 'api@octo.ai'
end

#
# The global recipes
#
Dir[ROOT + '/lib/**/*.god'].each do |file|
  puts "Loading from God file: #{ file }"
  God.load file
end

# This will ride alongside god and kill any rogue memory-greedy
# processes. Their sacrifice is for the greater good.

unicorn_worker_memory_limit = 300_000

Thread.new do
  loop do
    begin
      # unicorn workers
      #
      # ps output line format:
      # 31580 275444 unicorn_rails worker[15] -c /data/github/current/config/unicorn.rb -E production -D
      # pid ram command

      lines = `ps -e -www -o pid,rss,command | grep '[u]nicorn_rails worker'`.split("\n")
      lines.each do |line|
        parts = line.split(' ')
        if parts[1].to_i > unicorn_worker_memory_limit
          # tell the worker to die after it finishes serving its request
          ::Process.kill('QUIT', parts[0].to_i)
        end
      end
    rescue Object
      # don't die ever once we've tested this
      nil
    end

    sleep 30
  end
end

