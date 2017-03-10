%
% 知能情報工学科　卒論・修論用
%
%   2017/1/26 (by 江本): 表紙付きで PDF にしたいので AIcover.cls などをひとまとめに。
%   2017/1/30 (by 江本): カバー出力などのオプション化、bug fix、
%
%  TODO: デフォルトフォントサイズのオプション化？　カバー等のフォントを直接指定する改変が必要。
%
\NeedsTeXFormat{pLaTeX2e}
\RequirePackage{plext}
\ProvidesClass{AIthesis}[2017/1/26 v0.2]
%
%
% 修論, 卒論共通化のための識別子
\newif\ifMorB
%
\DeclareOption{bachelor}{\MorBfalse}	% default
\DeclareOption{master}{\MorBtrue}
%
% Inherited options 
%
\newif\ifdraft
\DeclareOption{draft}{\drafttrue}
\DeclareOption{final}{\draftfalse}
\DeclareOption{oneside}{\@twosidefalse}
\DeclareOption{twoside}{\@twosidetrue}
%
% Options for generating coverI, spine, coverII and lastpage (copyright).
%
\newif\ifcoverI
\DeclareOption{nocoverI}{\coverIfalse}
\DeclareOption{coverI}{\coverItrue}
\newif\ifcoverII
\DeclareOption{nocoverII}{\coverIIfalse}
\DeclareOption{coverII}{\coverIItrue}
\newif\ifspine
\DeclareOption{nospine}{\spinefalse}
\DeclareOption{spine}{\spinetrue}
\newif\ifcopyright
\DeclareOption{nocopyright}{\copyrightfalse}
\DeclareOption{copyright}{\copyrighttrue}

\ExecuteOptions{bachelor,coverI,coverII,spine,copyright}
\ProcessOptions\relax
\LoadClass[a4paper,onecolumn,11pt%
\ifdraft ,draft\else ,final\fi%
\if@twoside ,twoside,openright\else ,oneside,openany\fi%
]{jreport}
%
% 通常ページの寸法
%
\newcommand{\defaultGeom}{%
%\setlength{\voffset}{-15mm}
\setlength{\textheight}{220mm}
\setlength{\textwidth}{150mm}
\if@twoside
\setlength{\oddsidemargin}{10mm}
\setlength{\evensidemargin}{0mm}
\else
\setlength{\oddsidemargin}{10mm}
\setlength{\evensidemargin}{10mm}
\fi
%\setlength{\columnsep}{1pc}
%\setlength{\columnseprule}{0pt}
%\setlength{\baselineskip}{8mm}
\setlength{\topmargin}{6mm}
\setlength{\headheight}{0mm}
\setlength{\headsep}{0mm}
\setlength{\footskip}{20mm}}
%
\defaultGeom   % 通常の寸法にしておく
%
% カバーページの寸法
%
\newcommand{\coverGeom}{%
\setlength{\oddsidemargin}{5.6mm}   % TODO: ちゃんと計算しろ
\setlength{\evensidemargin}{5.6mm}
\setlength{\topmargin}{0mm}
\setlength{\headheight}{0pc}
\setlength{\headsep}{0pc}
\setlength{\footskip}{2pc}
\setlength{\textheight}{63pc}
\setlength{\textwidth}{42pc}}
%
% キャプションの変更
%
\long\def\@makecaption#1#2{
 \vskip 10pt 
 \setbox\@tempboxa\hbox{#1 #2}
 \ifdim \wd\@tempboxa >\hsize #1 #2\par \else \hbox
to\hsize{\hfil\box\@tempboxa\hfil} 
 \fi}
%
% 個別情報用（概要と共通のため、personal.tex に実データが置かれる）
%
\newcommand{\StudentName}{学生の氏名}
\newcommand{\StudentIDno}{00000000}
\newcommand{\SupervisorName}{指導教官の氏名}
\newcommand{\SupervisorTtl}{教授}
\newcommand{\SupervisorData}{指導教官の氏名, 肩書}
\newcommand{\ThesisTitle}{卒業論文の題目}
\newcommand{\YearofGrad}{2011}
\newcommand{\DivisionName}{所属部門名}
%
\newcommand{\Name}[1]{\renewcommand{\StudentName}{#1}}
\newcommand{\IDno}[1]{\renewcommand{\StudentIDno}{#1}}
\newcommand{\Supervisor}[2]{%
\renewcommand{\SupervisorName}{#1}%
\renewcommand{\SupervisorTtl}{#2}%
\renewcommand{\SupervisorData}{#1\quad#2}}
\newcommand{\Title}[1]{\renewcommand{\ThesisTitle}{#1}}
\newcommand{\Year}[1]{\renewcommand{\YearofGrad}{#1}}
\newcommand{\Division}[1]{\renewcommand{\DivisionName}{#1}}
% カバーページ達
\newcommand{\makeCoverPageI}{%
\coverGeom
\cleardoublepage
\newpage
{\large
\thispagestyle{empty}%
\setcounter{page}{0}
\vspace*{7mm}
\begin{center}
\setlength{\unitlength}{1mm}
\begin{picture}(134,200) %,200)
\put(22, 54){\dashbox{0.6}(90,0){}}
\put(22, 37){\dashbox{0.6}(90,0){}}
\put(22,210){\makebox(90,12){\huge%
\ifMorB{修 \ 士 \ 論 \ 文}%
  \else{卒 \ 業 \ 論 \ 文}%
\fi%
}}
\put( 0,189){\makebox(20,5){\large 論文題目}}
\put(22,118){\makebox(20,5){\large 指導教員}}
\put(22, 58){\makebox(20,5){\large \ifMorB{修了}\else{卒業}\fi{}年度}}
\put(22, 41){\makebox(20,5){\large 学生番号}}
\put(22, 25){\makebox(13,8){\large 氏名}}
\put( 0, 76){\makebox(134,8){\LARGE
\ifMorB{九州工業大学大学院情報工学府先端情報工学専攻}
  \else{九州工業大学情報工学部知能情報工学科}
\fi%
}}
\put( 0,143){\dashbox{0.6}(134,43){}}
\put(22, 94){\dashbox{0.6}(90,20){}}
\put(22,  0){\dashbox{0.6}(90,23){}}
%
%
\put(0,143){\makebox(134,43){\Large\shortstack{\ThesisTitle}}}
%							% 論文題目
\put(22,94){\makebox(90,20){\Large \SupervisorData}}	% 指導教員
\put(22, 0){\makebox(90,23){\Large \StudentName}}	% 氏名
\put(22,58){\makebox(90, 5){\Large \YearofGrad}}	% 卒業年度
\put(22,41){\makebox(90, 5){\Large \StudentIDno}}	% 学生番号
%
%
\end{picture}
\end{center}
}
\defaultGeom
}
%
%
%
\newcommand{\makeCoverPageII}{%
\coverGeom
\cleardoublepage
\newpage
{\large
\thispagestyle{empty}%
\if@twoside \setcounter{page}{1} \else \setcounter{page}{0} \fi
\vspace*{15mm}
\begin{center}{\huge%
\ifMorB{修 \ 士 \ 論 \ 文}
  \else{卒 \ 業 \ 論 \ 文}
\fi%
}\end{center}
\begin{center}
\vspace*{15mm}
\mbox{{\LARGE\shortstack{\ThesisTitle}}}	% 論文題目
\end{center}
\vspace{30mm}
\begin{center}
\makebox[0mm][r]{\Large 指導教員:\hspace{35mm}}
\makebox[0mm]{\LARGE \SupervisorData}		% 指導教員
\end{center}
\vspace{30mm}
\begin{center}{\LARGE
\ifMorB{九州工業大学大学院情報工学府 \\ 先端情報工学専攻}
  \else{九州工業大学情報工学部 \\ 知能情報工学科}
\fi%
}\end{center}
\vspace{15mm}
\begin{center}
{\Large \YearofGrad} \large 年度
\end{center}
\vspace{15mm}
\begin{center}
{\LARGE \StudentName}				% 学生氏名
\end{center}
}
\if@twoside \newpage \setcounter{page}{0} \else \relax \fi
\defaultGeom
}
%
%
%
\newcommand{\makeSpine}{%
\coverGeom
\cleardoublepage
\newpage
{\large
\thispagestyle{empty}%
\setcounter{page}{0}
\begin{flushleft}
\setlength{\unitlength}{1mm}
% TODO: this is too big, to make an empty page at the beginning
\begin{picture}(13,246)   
\thicklines
\put(0,  0){\line(1,0){13}}
\put(0, 56){\line(1,0){13}}
\put(0, 64){\line(1,0){13}}
\put(0, 80){\line(1,0){13}}
\put(0, 88){\line(1,0){13}}
\put(0,238){\line(1,0){13}}
\put(0,246){\line(1,0){13}}
\put(0,  0){\line(0,1){246}}
\put(13, 0){\line(0,1){246}}
\put(0,238){\makebox(13,8){\large 題目}}
\put(0, 80){\makebox(13,8){\large 年度}}
\put(0, 56){\makebox(13,8){\large 氏名}}
%
% 題目の変更
%
\put(0, 88){\makebox(13,150)
%%%%% 1行用
%% {\LARGE \parbox<t>{20zw}{\\input{title}}}}
%%%%% 2行用
{\Large \shortstack{\parbox<t>{30zw}{\ThesisTitle}}}}
%
%
%
\put(0, 64){\makebox(13,16){\LARGE \YearofGrad}}
\put(0,  0){\makebox(13,56){\LARGE\shortstack{\parbox<t>{7zw}{\StudentName}}}}
\end{picture}
\end{flushleft}
}\defaultGeom
}
%
%
%
\newcommand{\lastPage}{%
\cleardoublepage
\newpage
\thispagestyle{empty}
\null\vfill
\begin{flushleft}
\noindent Copyright {\copyright} {\number\year},~%
\StudentName.
\end{flushleft}\par

\noindent 大学は、本論文の複製権・公衆送信権を保有します。
\vspace{15mm}

署名： \rule{100mm}{.1pt}
}
%
%  関連図書 → 参考文献
%  
\renewcommand{\bibname}{参考文献}
%
%
%
\AtBeginDocument{%
\input{personal}         % individual data: name, student id, titile, ...
\ifcoverI  \makeCoverPageI  \else \relax \fi  % binder face
\ifspine   \makeSpine       \else \relax \fi  % binder spine
\ifcoverII \makeCoverPageII \else \relax \fi  % inner face
}
\AtEndDocument{%
\ifcopyright \lastPage \else \relax \fi  % copyright notice  
}
%

%% end of AIthesis.cls
