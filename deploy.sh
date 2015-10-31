sudo apt-get update
sudo apt-get install git -y
sudo apt-get install bundler -y
sudo apt-get install libsqlite3-dev -y
sudo apt-get install postgresql -y
sudo apt-get install libpq-dev -y

git clone https://github.com/thedoroemons/yell_api.git
cd yell_api
bundle install
mkdir p
mkdir logs
unicorn -c unicorn.rb -s puma -E production -D
