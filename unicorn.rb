@path = "./"

worker_processes 5 # CPUのコア数に揃える
working_directory @path
timeout 300
pid "./p/unicorn.pid" # pidを保存するファイル
stderr_path "./logs/err.log"
stdout_path "./logs/out.log"
preload_app true
listen 9292
