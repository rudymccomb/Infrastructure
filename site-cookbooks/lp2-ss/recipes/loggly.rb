# drop logging privileges to the correct group
bash "set-rsyslog-correct-privileges" do
  not_if "grep '^\$PrivDropToGroup adm$' rsyslog.conf"
  user "root"
  code <<-EOT
    sed -e 's/\$PrivDropToGroup syslog$/$PrivDropToGroup adm/' -i /etc/rsyslog.conf
  EOT
  notifies :restart, "service[rsyslog]", :immediately
end

lp2_secrets = Chef::EncryptedDataBagItem.load("lp2", "secrets")
customer_token = lp2_secrets[node.chef_environment]["loggly"]["customer_token"]

template "/etc/rsyslog.d/60-tomcat.conf" do
  owner "root"
  group "root"
  mode "0644"
  variables({
    :customer_token => customer_token,
    :logging_tag => node.name.downcase.gsub(/_/, '-'),
    :env => node.chef_environment.to_s
  })
  notifies :restart, "service[rsyslog]", :immediately
end

service "rsyslog" do
  action :nothing
  supports :restart => true
end
