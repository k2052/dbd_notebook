# Whenever sSchedule file. 
# See https://github.com/javan/whenever    

every 2.hours do
  command "cd /home/ubuntu/notebook.designbreakdown.com/dbd_notebook && bundle exec padrino rake backup:runit trigger='mongodb-backup-s3' "
end        

# every 25.minutes do       
#   command "cd /home/ubuntu/notebook.designbreakdown.com/dbd_notebook && bundle exec padrino rake navvy:work"
# end