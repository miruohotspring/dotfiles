local options = {
    encoding='utf-8',
    fileencoding='utf-8',
    number=true,                                                -- 行番号
    autoindent=true,                                            -- 改行時自動インデント
    softtabstop=2,                                              -- タブ空白文字数
    tabstop = 2,                                                -- タブ文字の空白数
    shiftwidth=2,                                               -- 自動インデント時の空白数
    expandtab=true,                                             -- タブ文字を空白に変換
    scrolloff=5,                                                -- スクロール時の余白
    swapfile=false,                                             -- swapファイルを作らない
    backup=false,                                               -- バックアップしない
    switchbuf=useopen,                                          -- 既に開いているバッファを開く
    shiftround=true,                                            -- shiftwidthで丸める
    infercase=true,                                             -- 補完時のcaseを無視
    hidden=true,                                                -- 保存せずに他のファイルを表示
    ignorecase=true,                                            -- 検索時小文字/大文字を無視
    smartcase=true,                                             -- 大文字を含めた際は上記設定を無視
    mouse=a,                                                    -- マウス有効化
    showmode=false,                                             -- モード表示しない
    clipboard='unnamedplus',
    cursorline=true,
    list=true,
    listchars='tab:»-,trail:-,extends:»,precedes:«,nbsp:%',
    termguicolors=true,
    splitright=true,
    splitbelow=true,
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")   -- 行を跨いで移動
vim.cmd([[set iskeyword+=-]])           --
vim.cmd([[set conceallevel=0 ]])

vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])

vim.g.markdown_fenced_languages = {'java'}
vim.opt.shell='fish'
