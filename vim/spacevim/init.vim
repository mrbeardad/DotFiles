execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'

colorscheme default

set ignorecase
set smartcase
set nowrapscan
set noshowmode
set noruler
set showcmd
set cmdheight=1
set lazyredraw
set wildignorecase
set showmatch
set matchtime=0
set nowrap
set linebreak
set scrolloff=1
set autochdir
set noautoread
set hidden
set mouse=a
set belloff=
set whichwrap=<,>,[,]
set virtualedit=block,onemore
set noswapfile
set nobackup
set undofile
set foldmethod=indent
set nofoldenable
set path=/usr/include/c++/**,.
set list
set listchars=tab:▸\ ,trail:∙,extends:↷,precedes:↶

autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
command! -nargs=* Rcmd :let tmp=<q-args> | put =execute(tmp)

"================================
" => Buffer、Window、Tab 操作
"================================
nnoremap <silent> <space>n :bn<CR>
nnoremap <silent> <space>b :bp<CR>
nnoremap <silent> <c-w>W :w !sudo tee % > /dev/null<CR>l<CR>
nnoremap <silent> <c-w>x :bd<CR>
nmap <silent> <c-w>X [SPC]bc

"================================
" => 插入模式快捷键
"================================
inoremap <c-a> <c-c>^i
inoremap <c-e> <end>
inoremap <c-u> <c-c><right>d^i
inoremap <c-k> <c-c><right>d$i
inoremap <c-d> <c-c><right>10<c-e>i
inoremap <c-b> <c-c><right>10<c-y>i
inoremap <c-]> <c-c>%i

"================================
" => 命令模式快捷键
"================================
cnoremap <c-a> <c-b>

"================================
" => 可视模式快捷键
"================================
vnoremap <c-a> 0
vnoremap <c-e> $

"================================
" => 普通模式快捷键
"================================
nnoremap <silent> <c-d> 10<c-e>
nnoremap <silent> <c-b> 10<c-y>
nnoremap <silent> <c-a> ^
nnoremap <silent> <c-e> $
nnoremap <silent> , yl
nnoremap <silent> Y y$
nmap <silent> <c-y> [SPC]bY
nmap + [SPC]n+
nmap - [SPC]n-
nmap <c-o> [SPC]jb
nmap <c-i> [SPC]jf
nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]
nnoremap <silent> ]<space> :<c-u>put =repeat(nr2char(10), v:count1)<CR><up>
nnoremap <silent> [<space> :<c-u>put! =repeat(nr2char(10), v:count1)<CR><down>
nnoremap <silent> <Leader>h :nohl<CR>

function! ToggleLinebreak()
    if &linebreak == 1
        setl nolinebreak
    else
        setl linebreak
    endif
endfunction
nnoremap <silent> <leader>l :call ToggleLinebreak<cr>

function! ToggleWrap()
    if &wrap == 1
        setl nowrap
    else
        setl wrap
    endif
endfunction
nnoremap <silent> <Leader>w :call ToggleWrap()<CR>

function! ToggleVirtuledit()
    if &virtualedit =~ "all"
        setl virtualedit=block,onemore
    else
        setl virtualedit=all
    endif
endfunction
nnoremap <silent> <leader>v :call ToggleVirtuledit()<CR>

function! ToggleExpandtab()
    if &expandtab == 1
        setl noexpandtab
    else
        setl expandtab
    endif
endfunction
nnoremap <silent> <leader>te :call ToggleExpandtab()<CR>

"================================================ 插件配置 ======================================================

" ================================
" => OpenBrowser配置
" ================================
nmap <space>ao <Plug>(openbrowser-open)

"================================
" => Easymotion配置
"================================
let g:EasyMotion_smartcase = 1
nmap ; [SPC]jJ
hi EasyMotionShade guibg=none guifg=grey

"================================
" => Defx配置
"================================
let g:defx_git#indicators = {'Untracked': '⟴', 'Unmerged': '≠', 'Ignored': '•', 'Renamed': '🗘', 'Modified': '⬍', 'Deleted': '✖', 'Unknown': '⁇', 'Staged': '⥥'}

"================================
" => GitGutter配置
"================================
let g:gitgutter_enabled = 0

"================================
" => Undotree配置
"================================
nnoremap <silent> <F4> :UndotreeToggle<CR>

"================================
" => IndentLine配置
"================================
let g:indentLine_fileType = ['c', 'cpp', 'sh']
let g:indentLine_char = '┆'

"================================
" => Rainbow-Parentheses配置
"================================
au VimEnter * RainbowParentheses

"================================
" => Cpp_Enhanced_Highlight配置
"================================
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1           " which is a faster implementation but has some corner cases where it doesn't work.
" let g:cpp_experimental_simple_template_highlight = 1  " which works in most cases, but can be a little slow on large files

"================================
" => UltiSnips配置
"================================
let g:UltiSnipsExpandTrigger = '<m-q>'
let g:UltiSnipsJumpBackwardTrigger = '<m-b>'
let g:UltiSnipsJumpForwardTrigger = '<m-m>'

"================================
" => Echodoc配置
"================================
let g:echodoc#enable_at_startup = 1

"================================
" => Instant-Markdown配置
"================================
let g:instant_markdown_autostart = 0

"================================
" => LeaderF配置
"================================
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_RootMarkers = ['.git/', '.root', '_darcs/', '.hg/', '.bzr/', '.svn/', '.SpaceVim.d/']
let g:Lf_WildIgnore = {
        \ 'dir': ['.svn', '.git', '.root'],
        \ 'file': ['.root', '*.bak', '*.save', '*.o', '*.so']
        \}
nnoremap <silent> <leader>ft :Leaderf bufTag --all<CR>
nnoremap <silent> <leader>ff :Leaderf <CR>
nnoremap <silent> <leader>fg :Leaderf gtags<CR>
nnoremap <silent> <leader>fc :Leaderf gtags --grep<CR>
nnoremap <silent> <leader>fu :Leaderf gtags --update<CR>
nnoremap <silent> gr :Leaderf! gtags -r  <c-r>=expand('<cword>')<cr> --auto-jump<cr>
nnoremap <silent> gd :Leaderf! gtags -d  <c-r>=expand('<cword>')<cr> --auto-jump<cr>
nnoremap <silent> gs :Leaderf! gtags -s  <c-r>=expand('<cword>')<cr> --auto-jump<cr>

"================================
" => Cscope配置
"================================
set cscopeprg=/usr/local/bin/gtags-cscope
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
set nocst
nnoremap <silent> <leader>ca :cscope find a  <c-r>=expand('<cword>')<cr><cr>
nnoremap <silent> <leader>cg :cscope find g  <c-r>=expand('<cword>')<cr><cr>
nnoremap <silent> <leader>cc :cscope find c  <c-r>=expand('<cword>')<cr><cr>
nnoremap <silent> <leader>ct :cscope find t  <c-r>=expand('<cword>')<cr><cr>
nnoremap <silent> <leader>ce :cscope find e  <c-r>=expand('<cword>')<cr><cr>
nnoremap <silent> <leader>cf :cscope find f  <c-r>=expand('<cfile>')<cr><cr>
nnoremap <silent> <leader>ci :cscope find i ^<c-r>=expand('<cfile>')<cr>$<cr>
nnoremap <silent> <leader>cd :cscope find d  <c-r>=expand('<cword>')<cr><cr>

"================================
" => ALE配置
"================================
let g:ale_linters = {
      \   'cpp': ['clangtidy', 'cppcheck', 'gcc'],
      \   'c': ['gcc', 'cppcheck'],
      \   'sh': ['shell'],
      \}
let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_set_highlights = 1
let g:ale_echo_msg_format = '[%linter%] %s  [%severity%]'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_c_gcc_options = '-Wall -Wextra -O2 -std=c11'
let g:ale_c_cppcheck_options = '--enable=warning,style,performance,portability,information --std=c11'
let g:ale_cpp_gcc_options = '-Wall -Wextra -O2 -std=c++17'
let g:ale_cpp_cppcheck_options = '--enable=warning,style,performance,portability,information --std=c++17'
let g:ale_cpp_clangtidy_options = '-extra-arg=-Weverything -extra-arg=-Wno-c++98-compat -extra-arg=-Wno-c++98-compat-pedantic -extra-arg=-Wno-pedantic -extra-arg=-Wno-missing-prototypes -extra-arg=-Wno-padded -extra-arg=-Wno-old-style-cast -extra-arg=-O2 -extra-arg=-std=c++17'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_sign_info = '‼'
let g:ale_echo_msg_error_str = '✗'
let g:ale_echo_msg_warning_str = '⚡'
let g:ale_echo_msg_info_str = '‼'
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=yellow
hi! SpellRare gui=undercurl guisp=magenta
" nnoremap <silent> gn :ALENextWrap<CR>
" nnoremap <silent> gb :ALEPreviousWrap<CR>
" let g:is_ALE_Running = 1
" function! ToggleALE()
    " if g:is_ALE_Running == 1
        " let g:is_ALE_Running = 0
        " ALEToggle
        " echo 'ALE Disable!'
    " else
        " let g:is_ALE_Running = 1
        " ALEToggle
        " echo 'ALE Enable!'
    " endif
" endfunction
" nnoremap <silent> <space>a :call ToggleALE()<cr>

"================================
" => YCM配置
"================================
let g:ycm_filetype_whitelist = {
        \ "c":1,
        \ "cpp":1,
        \ "vim":1,
        \ "sh":1,
        \ "zsh":1,
        \ }
let g:ycm_semantic_triggers =  {
        \ 'c,cpp,sh': ['re!\w{2}'],
        \ }
let g:ycm_add_preview_to_completeopt = 0
set completeopt=menu,menuone
let g:ycm_use_clangd = 1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_confirm_extra_conf=0
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_complete_in_comments=0
let g:ycm_complete_in_strings=0
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_key_list_stop_completion = ['<CR>']
let g:ycm_key_invoke_completion = '<c-z>'
nnoremap gp :YcmCompleter GetParent<CR>
nnoremap gt :YcmCompleter GetType<CR>
nnoremap go :YcmCompleter GoTo<CR>

"================================
" => QuickRun配置
"================================
let g:QuickRunArgs=''
let g:QuickRunRedirect=''
let g:QuickRunBufnr=0
let g:QuickRun_PATH=''
command! -nargs=1 QuickrunArgs let g:QuickRunArgs = <q-args>
command! -nargs=1 QuickrunRedirect let g:QuickRunRedirect = <q-args>
command! QuickInput execute 'let g:QuickRunRedirect = "-i /tmp/' . expand('%:r') . '.input"'
function! QuickRun()
    if !isdirectory('/tmp/QuickRun')
        !mkdir /tmp/QuickRun
    endif
    if !isdirectory('/sys/fs/cgroup/memory/test')
        !sudo mkdir /sys/fs/cgroup/memory/test
    endif
    if g:QuickRunBufnr != 0 && bufexists(g:QuickRunBufnr)
        execute 'bd ' . g:QuickRunBufnr
    endif
    if &modified == 0 && g:QuickRun_PATH =~ expand('%:r')
        rightbelow 15 split
        execute 'term ++noclose ++norestore ++curwin sh -c "sudo sh -c \"echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs\" && sudo sh -c \"echo 500M | tee /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes > /sys/fs/cgroup/memory/test/memory.limit_in_bytes\"'
                    \ . ' && echo -e \"\\e[1;33mNote: Rerunning last compiled program!\\e[m\" && quickrun_time '
                    \ . g:QuickRunRedirect . ' ' . g:QuickRun_PATH . ' ' . g:QuickRunArgs . '"'
    else
        write
        rightbelow 15 split
        let QuickRun_TIME = strftime('%M%H')
        let QuickRun_FILE = expand('%:r')
        let g:QuickRun_PATH = '/tmp/QuickRun/' . QuickRun_FILE . '.' . QuickRun_TIME
        execute 'term ++noclose ++norestore ++curwin sh -c "sudo sh -c \"echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs\" && sudo sh -c \"echo 500M | tee /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes > /sys/fs/cgroup/memory/test/memory.limit_in_bytes\"'
                    \ ' && echo -e \"\\e[1;32m[Compile] ' . g:QuickRun_PATH .
                    \ '\\e[m\" && g++ -std=c++17 -O2 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I. -o ' . g:QuickRun_PATH . ' ' . expand('%') .
                    \ ' && quickrun_time ' . g:QuickRunRedirect . ' ' . g:QuickRun_PATH . ' ' . g:QuickRunArgs . '"'
    endif
    let g:QuickRunBufnr=bufnr('%')
    wincmd p
endfunction
nnoremap <silent> <space>lr :call QuickRun()<CR>
nnoremap <silent> <space>lt :execute 'bd ' g:QuickRunBufnr<cr>
nnoremap <silent> <space>ld :w<cr>:execute '!g++ -std=c++17 -Og -g3 -fno-inline -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I. -o ' . expand('%:r') . ' ' . expand('%')<CR>
nnoremap <silent> <space>lc :w<cr>:execute '!clang++ -std=c++17 -O3 -I. -o ' . expand('%:r') . ' ' . expand('%')<CR>
autocmd BufLeave *.input :w
nnoremap <silent> <space>li <c-w>v<c-w><right>30<c-w>\|:execute 'e /tmp/' . expand('%:r') . '.input'<cr>:wincmd p<cr>:QuickInput<cr>
"function! QuickrunInput()
    "let g:QuickRunInputFile=expand('%:r')
    "normal '<c-w><right><c-w>s'
    "execute 'e /tmp/' . g:QuickRunInputFile . '.input'
    "wincmd p
    "QuickrunInput
"endfunction

