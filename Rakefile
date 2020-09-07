require 'erb'
require 'find'
require 'fileutils'
require 'net/http'

task default: :all
  
task :all => [
  :install_lazygit,
  :install_nvim,
  :install_tmux,
  :install_fd,
  :install_ranger,
  :install_dotfiles,
  :source_bashrc_d,
  :install_vim_plug,
]

task :test do
  system(*%w{docker build -t dotfiles .}) and system(*%w{docker run --rm -ti dotfiles})
end

# platform specific tasks
task :install_lazygit do
  next if which('lazygit')

  raise 'could not install lazygit' unless \
    system(ENV.reject { |k| k == 'GOPATH'}, *%w{go get github.com/jesseduffield/lazygit})
end

task :install_ranger => [ :install_dotfiles ] do
  next if which('ranger')

  raise 'could not install ranger' unless if osx?
    brew_install('ranger')
  else
    apt_install('ranger')
  end
end

task :install_fd => [ :install_dotfiles ] do
  next if File.executable?(File.join(Dir.home, '.cargo/bin/fd')) 
  next if which('fd')

  raise 'could not install fd' unless if osx?
    brew_install('fd')
  else
    system(*%w{cargo install fd-find})
  end
end

task :install_nvim do
  next if which('nvim') && nvim_version(0,4,0)

  if RUBY_PLATFORM =~ /darwin/
    brew_install('neovim', head: true) or raise "could not install neovim"
  else
    apt_install(
      'software-properties-common',
      repos: ['ppa:neovim-ppa/stable'],
    ) or raise "could not install software-properties-common"
    system(*%w{sudo apt update}) or raise "could not apt-get update"
    apt_install('neovim') or raise "could not install neovim"
  end
end

task :install_tmux do
  next if which('tmux')

  raise 'could not install tmux' unless if osx?
    brew_install('tmux')
  else
    apt_install('tmux')
  end
end

# platform neutral tasks

task :install_vim_plug => [ :install_dotfiles ] do
  vim_plug_install_dir = File.join(Dir.home, '.config/nvim/autoload')
  vim_plug_install_file = File.join(vim_plug_install_dir, 'plug.vim')

  next if File.exists?(vim_plug_install_file)

  plug_vim_file = Net::HTTP.get(URI('https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'))

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
  source_bashrc_star = 'for file in ~/.bashrc.d/*.bash; do source "$file"; done'
  bashrc_path = File.join(Dir.home, '.bashrc')

  contains_source_bashrc_star = if File.exists?(bashrc_path)
                                  File.open(bashrc_path) do |bashrc|
                                    bashrc.each_line.to_a.map(&:chomp).include?(source_bashrc_star)
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

def nvim_version
  IO.popen('nvim -version').first.chomp.sub(/.*v/, '').split('.').map(&:to_i)
end

def nvim_version_at_least?(major, minor, fix)
  nvim_major, nvim_minor, nvim_fix = nvim_version

  return false if nvim_major < major 
  return false if nvim_minor < minor 
  return false if nvim_fix < fix 
  true
end

def which(command)
  system('which', command, :out => '/dev/null', :err => :out)
end

def osx?
  RUBY_PLATFORM.match(/darwin/)
end

def brew_install(packages, head: false)
  system(
    'brew',
    'install',
    *(head ? ['--HEAD'] : []),
    *packages
  )
end

def apt_add_repo(repo)
  system('sudo', 'add-apt-repository', '-y', repo)
end

def apt_install(packages, repos:[])
  system('sudo', 'apt', 'update') &&
    repos.all? { |repo| apt_add_repo(repo) } &&
    system('sudo', 'apt', 'install', '-y', *packages)
end

