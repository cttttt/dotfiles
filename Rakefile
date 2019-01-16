require 'erb'
require 'find'
require 'fileutils'
require 'net/http'

task default: :all
  
task :all => [
  :install_nvim,
  :install_tmux,
  :install_fd,
  :install_dotfiles,
  :source_bashrc_d,
  :install_vim_plug,
]

task :test do
  system(*%w{docker build -t dotfiles .}) and system(*%w{docker run --rm -ti dotfiles})
end

# platform specific tasks

task :install_fd => [ :install_dotfiles ] do
  next if File.executable?(File.join(Dir.home, '.cargo/bin/fd')) 
  next if system(*%w{which fd}, :out => '/dev/null', :err => :out)

  if RUBY_PLATFORM =~ /darwin/
    system(*%w{brew install fd}) or raise "could not install fd"
  else
    system(*%w{cargo install fd-find}) or raise "could not install fd.  Is rust install?"
  end
end

task :install_nvim do
  next if system(*%w{which nvim}, :out => '/dev/null', :err => :out)

  if RUBY_PLATFORM =~ /darwin/
    system(*%w{brew install neovim}) or raise "could not install neovim"
  else
    system(*%w{sudo apt install -y software-properties-common}) or raise "could not install add-apt-repository"
    system(*%w{sudo add-apt-repository -y ppa:neovim-ppa/stable}) or raise "could not add ppa"
    system(*%w{sudo apt update}) or raise "could not apt-get update"
    system(*%w{sudo apt install -y neovim}) or raise "could not install neovim"
  end
end

task :install_tmux do
  next if system(*%w{which tmux}, :out => '/dev/null', :err => :out)

  if RUBY_PLATFORM =~ /darwin/
    system(*%w{brew install tmux}) or raise "could not install tmux"
  else
    system(*%w{sudo apt update}) or raise "could not apt-get update"
    system(*%w{sudo apt install -y tmux}) or raise "could not install tmux"
  end
end

# platform neutral tasks

task :install_vim_plug => [ :install_dotfiles ] do
  plug_vim_file = Net::HTTP.get(URI('https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'))
  vim_plug_install_dir = File.join(Dir.home, '.config/nvim/autoload')
  vim_plug_install_file = File.join("#{vim_plug_install_dir}/plug.vim")

  next if File.exists?(vim_plug_install_file)

  Dir.mkdir(vim_plug_install_dir)
  File.open(vim_plug_install_file, 'w') do |plug_vim|
    plug_vim.write(plug_vim_file)
  end
  
  install_plug_command = [ *%w{nvim --cmd}, 'set shortmess=a', '--cmd', 'source ~/.vimrc', '--cmd', 'PlugInstall', '--cmd', 'qa!' ]

  3.times do
    system(*install_plug_command, :out => '/dev/null', :err => :out)
  end
end

task :source_bashrc_d do
  source_bashrc_star = 'for file in ~/.bashrc.d/*; do source "$file"; done'
  bashrc_path = File.join(Dir.home, '.bashrc')

  contains_source_bashrc_star = if File.exists?(bashrc_path)
                                  File.open(bashrc_path) do |bashrc|
                                    bashrc.each_line.to_a.include?(source_bashrc_star)
                                  end
                                end

  next if contains_source_bashrc_star

  File.open(File.join(Dir.home, '.bashrc'), 'a') do |bashrc|
    bashrc.puts(source_bashrc_star)
  end
end

task :install_dotfiles do
  dotfile_dir = File.realpath('dot', __dir__)

  Find.find(dotfile_dir) do |path|
    next if path == dotfile_dir

    path_in_home =  path
      .sub(dotfile_dir, '')
      .sub(/^\/?/, '/.')
      .sub(/^/, Dir.home)

    path_in_home = path_in_home.sub(/\.erb$/, '')

    if File.symlink?(path_in_home) || File.exist?(path_in_home)
      unless File.directory?(path)
        begin
          File.unlink("#{path_in_home}.orig")
        rescue Errno::ENOENT
        end

        File.rename(path_in_home, "#{path_in_home}.orig")
      end
    end

    unless File.exist?(path_in_home)
      if File.directory?(path)
        Dir.mkdir(path_in_home)
      elsif path =~ /\.erb$/
        erb = ERB.new(File.read(path))
        File.write(path_in_home, erb.result)
      else
        FileUtils.ln_s(path, path_in_home)
      end
    end
  end
end
