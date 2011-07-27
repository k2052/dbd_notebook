# Use at least one worker per core
worker_processes 2 

# Help ensure your application will always spawn in the symlinked "current" directory that Capistrano sets up
working_directory "/home/root/kerickson.me/me" 

# Listen on a Unix domain socket, use the default backlog size
listen "/tmp/me.sock", :backlog => 1024

# Nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# Lets keep our process id's in one place for simplicity  
pid "/home/root/kerickson.me/me/pids/unicorn.pid"

# Logs are very useful for trouble shooting, use them 
stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"
