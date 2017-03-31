apt-get update
apt-get install -y build-essential
adduser --system --disabled-password --gecos "Riak User" --quiet riak
adduser --disabled-password --quiet --gecos "Cogility User" cogility
echo "cogility:C0gility" | chpasswd
mkdir -p /home/cogility/.ssh
cat /home/ubuntu/.ssh/authorized_keys > /home/cogility/.ssh/authorized_keys
chown -R cogility:cogility /home/cogility/.ssh
echo "cogility ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/95-cogility-users
git clone https://github.com/asdf-vm/asdf.git /home/cogility/.asdf --branch v0.2.1
# For Ubuntu or other linux distros
echo -e '\n. $HOME/.asdf/asdf.sh' >> /home/cogility/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> /home/.bashrc
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y esl-erlang elixir
curl -s https://packagecloud.io/install/repositories/basho/riak/script.deb.sh | bash
apt-get install -y riak 
git clone https://cogilitydevops:9a2c1f5467d6dc33b3724c3d74b80187eadc7f30@github.com/Cogility/icss_otp.git /home/cogility/icss_otp
riak start
riak-admin bucket-type create maps '{"props":{"datatype":"map"}}'
riak-admin bucket-type create sets '{"props":{"datatype":"set"}}'
riak-admin bucket-type create counters '{"props":{"datatype":"counter"}}'
riak-admin bucket-type create hlls '{"props":{"datatype":"hll"}}'
riak-admin bucket-type status maps
riak-admin bucket-type status sets
riak-admin bucket-type status counters
riak-admin bucket-type status hlls
riak-admin bucket-type activate maps
riak-admin bucket-type activate sets
riak-admin bucket-type activate counters
riak-admin bucket-type activate hlls
cd /home/cogility/icss_otp
mix local.hex --force
mix local.rebar --force
yes | mix deps.get