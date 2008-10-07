" vim600: set foldmethod=marker:
"
" Perforce extension for VCSCommand.
"
" Version:       VCS development
" Maintainer:    Jason Foreman <jason@threeve.org>
" License:
" Copyright (c) 2008 Jason Foreman
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"
" Section: Documentation {{{1
"
" Options documentation: {{{2
"
" VCSCommandPerforceExec
"   This variable specifies the p4 executable.  If not set, it defaults to
"   'p4' executed from the user's executable path.
"
" VCSCommandPerforceDiffOpt
"   This variable, if set, determines the default options passed to the
"   VCSDiff command.  If any options (starting with '-') are passed to the
"   command, this variable is not used.

" Section: Plugin header {{{1

if exists('VCSCommandDisableAll')
	finish
endif

if v:version < 700
	echohl WarningMsg|echomsg 'VCSCommand requires at least VIM 7.0'|echohl None
	finish
endif

runtime plugin/vcscommand.vim

if !executable(VCSCommandGetOption('VCSCommandPerforceExec', 'p4'))
	" p4 is not installed
	finish
endif

let s:save_cpo=&cpo
set cpo&vim

" Section: Variable initialization {{{1

let s:p4Functions = {}

" Section: Utility functions {{{1

" Function: s:DoCommand(cmd, cmdName, statusText, options) {{{2
" Wrapper to VCSCommandDoCommand to add the name of the p4 executable to the
" command argument.
function! s:DoCommand(cmd, cmdName, statusText, options)
	if VCSCommandGetVCSType(expand('%')) == 'p4'
		let fullCmd = VCSCommandGetOption('VCSCommandPerforceExec', 'p4',) . ' ' . a:cmd
		return VCSCommandDoCommand(fullCmd, a:cmdName, a:statusText, a:options)
	else
		throw 'p4 VCSCommand plugin called on non-p4 item.'
	endif
endfunction

" Section: VCS function implementations {{{1

" Function: s:p4Functions.Identify(buffer) {{{2
" This function only returns an inexact match due to the detection method used
" by p4, which simply traverses the directory structure upward.
function! s:p4Functions.Identify(buffer)
	let oldCwd = VCSCommandChangeToCurrentFileDir(resolve(bufname(a:buffer)))
	try
		let info = system(VCSCommandGetOption('VCSCommandPerforceExec', 'p4') . ' info')
		if(v:shell_error)
			return 0
		else
            let lines = split(info, '\n')
            let root = matchlist(lines, '^Client root: \(.*\)')[1]
            if stridx(getcwd(), root) == 0
                return g:VCSCOMMAND_IDENTIFY_EXACT
            else
    			return 0
            endif
		endif
	finally
		call VCSCommandChdir(oldCwd)
	endtry
endfunction

" Function: s:p4Functions.Add(argList) {{{2
function! s:p4Functions.Add(argList)
	return s:DoCommand(join(['add'] + ['-v'] + a:argList, ' '), 'add', join(a:argList, ' '), {})
endfunction

" Function: s:p4Functions.Annotate(argList) {{{2
function! s:p4Functions.Annotate(argList)
	if len(a:argList) == 0
		if &filetype == 'p4Annotate'
			" Perform annotation of the version indicated by the current line.
			let options = matchstr(getline('.'),'^\x\+')
		else
			let options = ''
		endif
	elseif len(a:argList) == 1 && a:argList[0] !~ '^-'
		let options = a:argList[0]
	else
		let options = join(a:argList, ' ')
	endif

	let resultBuffer = s:DoCommand('blame ' . options . ' -- ', 'annotate', options, {})
	if resultBuffer > 0
		normal 1G
		set filetype=p4Annotate
	endif
	return resultBuffer
endfunction

" Function: s:p4Functions.Commit(argList) {{{2
function! s:p4Functions.Commit(argList)
	let resultBuffer = s:DoCommand('commit -F "' . a:argList[0] . '"', 'commit', '', {})
	if resultBuffer == 0
		echomsg 'No commit needed.'
	endif
	return resultBuffer
endfunction

" Function: s:p4Functions.Delete() {{{2
" All options are passed through.
function! s:p4Functions.Delete(argList)
	let options = a:argList
	let caption = join(a:argList, ' ')
	return s:DoCommand(join(['rm'] + options, ' '), 'delete', caption, {})
endfunction

" Function: s:p4Functions.Diff(argList) {{{2
" Pass-through call to p4-diff.  If no options (starting with '-') are found,
" then the options in the 'VCSCommandPerforceDiffOpt' variable are added.
function! s:p4Functions.Diff(argList)
	let p4DiffOpt = VCSCommandGetOption('VCSCommandPerforceDiffOpt', '')
	if p4DiffOpt == ''
		let diffOptions = []
	else
		let diffOptions = [p4DiffOpt]
		for arg in a:argList
			if arg =~ '^-'
				let diffOptions = []
				break
			endif
		endfor
	endif

	let resultBuffer = s:DoCommand(join(['diff'] + diffOptions + a:argList), 'diff', join(a:argList), {})
	if resultBuffer > 0
		set filetype=diff
	else
		echomsg 'No differences found'
	endif
	return resultBuffer
endfunction

" Function: s:p4Functions.GetBufferInfo() {{{2
" Provides version control details for the current file.  Current version
" number and current repository version number are required to be returned by
" the vcscommand plugin.  This CVS extension adds branch name to the return
" list as well.
" Returns: List of results:  [revision, repository, branch]

function! s:p4Functions.GetBufferInfo()
	let oldCwd = VCSCommandChangeToCurrentFileDir(resolve(bufname('%')))
	try
        let filename = bufname(VCSCommandGetOriginalBuffer(bufnr('%')))
		let fstat = system(VCSCommandGetOption('VCSCommandPerforceExec', 'p4') . ' fstat ' . filename)
		if v:shell_error
			let have = '?'
		else
            let head = matchlist(fstat, 'headRev \(.\{-}\)\n')[1]
            let have = matchlist(fstat, 'haveRev \(.\{-}\)\n')[1]
		endif

		let info = [head, have]

		return info
	finally
		call VCSCommandChdir(oldCwd)
	endtry
endfunction

" Function: s:p4Functions.Log() {{{2
function! s:p4Functions.Log(argList)
	let resultBuffer=s:DoCommand(join(['log'] + a:argList), 'log', join(a:argList, ' '), {})
	if resultBuffer > 0
		set filetype=p4log
	endif
	return resultBuffer
endfunction

" Function: s:p4Functions.Revert(argList) {{{2
function! s:p4Functions.Revert(argList)
	return s:DoCommand('checkout', 'revert', '', {})
endfunction

" Function: s:p4Functions.Review(argList) {{{2
function! s:p4Functions.Review(argList)
	if len(a:argList) == 0
		let revision = 'HEAD'
	else
		let revision = a:argList[0]
	endif

	let oldCwd = VCSCommandChangeToCurrentFileDir(resolve(bufname(VCSCommandGetOriginalBuffer('%'))))
	try
		let prefix = system(VCSCommandGetOption('VCSCommandPerforceExec', 'p4') . ' rev-parse --show-prefix')
	finally
		call VCSCommandChdir(oldCwd)
	endtry

	let prefix = substitute(prefix, '\n$', '', '')
	let blob = '"' . revision . ':' . prefix . '<VCSCOMMANDFILE>"'
	let resultBuffer = s:DoCommand('show ' . blob, 'review', revision, {})
	if resultBuffer > 0
		let &filetype=getbufvar(b:VCSCommandOriginalBuffer, '&filetype')
	endif
	return resultBuffer
endfunction

" Function: s:p4Functions.Status(argList) {{{2
function! s:p4Functions.Status(argList)
	return s:DoCommand(join(['status'] + a:argList), 'status', join(a:argList), {'allowNonZeroExit': 1})
endfunction

" Function: s:p4Functions.Update(argList) {{{2
function! s:p4Functions.Update(argList)
	throw "This command is not implemented for p4 because file-by-file update doesn't make much sense in that context.  If you have an idea for what it should do, please let me know."
endfunction


" Section: Plugin Registration {{{1
call VCSCommandRegisterModule('p4', expand('<sfile>'), s:p4Functions, [])

let &cpo = s:save_cpo
