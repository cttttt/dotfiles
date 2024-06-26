# frozen_string_literal: true

require 'erb'
require 'find'
require 'fileutils'
require 'tmpdir'

task default: :all

task all: %i[
  install_dotfiles
  install_homebrew_git
  source_bashrc_d
  install_mise
  install_lazygit
  install_nvim
  install_tmux
  install_fd
  install_bat
  install_ranger
  install_ag
  install_rg
  install_bash_completion
  install_mason_things
  install_tmux_termcap
]

task :test do
  system(*%w[docker build -t dotfiles .]) and system(*%w[docker run --rm -ti dotfiles])
end

task :install_tmux_termcap do
  next unless osx?
  next if system(*%w[infocmp -x tmux-256color], out: '/dev/null', err: :out)

  system(*%w[/usr/bin/tic -x], 'cfg/tmux-256color.termcap')
end

task :install_homebrew_git do
  next unless osx?
  next if File.exist?('/opt/homebrew/etc/bash_completion.d/git-completion.bash')

  brew_install('git')
end

task :install_mise do
  next if which('mise')

  system('bash', '-c', 'curl https://mise.run | sh')
end

# platform specific tasks
task :install_lazygit do
  next if which('lazygit')

  raise 'could not install lazygit' unless \
    system(ENV.reject { |k| k == 'GOPATH' }, *%w[go install github.com/jesseduffield/lazygit@latest])
end

task :install_bash_completion do
  bash_completion_installed = [
    '/usr/share/bash-completion/bash_completion',
    '/etc/bash_completion',
    '/usr/local/etc/bash_completion',
    '/opt/homebrew/etc/profile.d/bash_completion.sh'
  ].find do |script|
    File.exist?(script)
  end

  next if bash_completion_installed

  raise 'could not install go lang toolchain' unless if osx?
                                                       brew_install('bash-completion')
                                                     else
                                                       apt_install('bash-completion')
                                                     end
end

task install_ranger: [:install_dotfiles] do
  next if which('ranger')

  raise 'could not install ranger' unless if osx?
                                            brew_install('ranger')
                                          else
                                            apt_install('ranger')
                                          end
end

task install_fd: [:install_dotfiles] do
  next if File.executable?(File.join(Dir.home, '.cargo/bin/fd'))
  next if which('fd')

  raise 'could not install fd' unless if osx?
                                        brew_install('fd')
                                      else
                                        system(*%w[cargo install fd-find])
                                      end
end

task :install_nvim do
  next if which('nvim') && nvim_version_at_least?(0, 9, 0)

  if RUBY_PLATFORM =~ /darwin/
    raise 'could not install neovim' unless brew_install('neovim', head: true)
  else
    apt_install(
      'software-properties-common',
      repos: ['ppa:neovim-ppa/unstable']
    ) or raise 'could not install software-properties-common'
    system(*%w[sudo apt update]) or raise 'could not apt-get update'
    apt_install('neovim') or raise 'could not install neovim'
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

task :install_bat do
  next if which('bat')

  raise 'could not install bat' unless if osx?
                                         brew_install('bat')
                                       else
                                         apt_install('bat')
                                       end
end

task :install_ag do
  next if which('ag')

  raise 'could not install ag' unless if osx?
                                        brew_install('the_silver_searcher')
                                      else
                                        apt_install('silversearcher-ag')
                                      end
end

task :install_rg do
  next if which('rg')

  raise 'could not install rg' unless if osx?
                                        brew_install('ripgrep')
                                      else
                                        apt_install('ripgrep')
                                      end
end

# platform neutral tasks

task install_mason_things: %i[install_dotfiles install_nvim] do
  next if
    which('gopls') &&
    which('solargraph') &&
    which('terraform-ls') &&
    which('gopls') &&
    which('rust-analyzer') &&
    which('gitui') &&
    which('solargraph') &&
    which('typescript-language-server')

  apt_install('ruby')

  system(
    'nvim',
    '--headless',
    '--cmd', 'set shortmess=a',
    '--cmd', 'source ~/.config/nvim/init.lua',
    '--cmd', 'MasonInstall terraform-ls gopls rust-analyzer ' \
             'gitui solargraph basedpyright python-lsp-server ' \
             'typescript-language-server actionlint',
    '--cmd', 'qall'
  )
end

task :source_bashrc_d do
  source_bashrc_star = 'for file in ~/.bashrc.d/*.bash; do source "$file"; done'
  bashrc_path = File.join(Dir.home, '.bashrc')

  contains_source_bashrc_star = if File.exist?(bashrc_path)
                                  File.open(bashrc_path) do |bashrc|
                                    bashrc.each_line.to_a.map(&:chomp).include?(source_bashrc_star)
                                  end
                                end

  next if contains_source_bashrc_star

  File.open(File.join(Dir.home, '.bashrc'), 'a') do |bashrc|
    bashrc.puts(source_bashrc_star)
  end
end

# rubocop:disable Metrics/BlockLength
task :install_dotfiles do
  dotfile_dir = File.realpath('dot', __dir__)

  Find.find(dotfile_dir) do |path|
    next if path == dotfile_dir

    path_in_home =  path
                    .sub(dotfile_dir, '')
                    .sub(%r{^/?}, '/.')
                    .sub(/^/, Dir.home)

    path_in_home = path_in_home.sub(/\.erb$/, '')

    if (File.symlink?(path_in_home) || File.exist?(path_in_home)) && !File.directory?(path)
      begin
        File.unlink("#{path_in_home}.orig")
      rescue Errno::ENOENT
        # do nothing
      end

      File.rename(path_in_home, "#{path_in_home}.orig")
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
# rubocop:enable Metrics/BlockLength

def nvim_version
  IO.popen('nvim -version').first.chomp.sub(/.*?v/, '').split(/[.-]/).map(&:to_i)
end

def nvim_version_at_least?(major, minor, fix)
  nvim_major, nvim_minor, nvim_fix = nvim_version

  return false if nvim_major < major
  return false if nvim_minor < minor
  return false if nvim_fix < fix

  true
end

def which(command)
  system('which', command, out: '/dev/null', err: :out)
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

def deb_install(deb)
  Dir.mktmpdir do |dir|
    package_filename = File.join(dir, 'package.deb')
    system('curl', '--location', '-o', package_filename, deb) &&
      system('sudo', 'dpkg', '-i', package_filename)
  end
end

def apt_add_repo(repo)
  system('sudo', 'add-apt-repository', '-y', repo)
end

def apt_install(packages, repos: [])
  system('sudo', 'apt', 'update') &&
    repos.all? { |repo| apt_add_repo(repo) or raise "could not add apt repo: #{repo}" } and
    system('sudo', 'apt-get', '--only-upgrade', 'install', '-y', *packages) and
    system('sudo', 'apt', 'install', '-y', *packages)
end
