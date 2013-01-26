%%
%% Diese Klasse steht unter CC0 (http://creativecommons.org/publicdomain/zero/1.0/)
%%
%% Written 2013 by Peter Barth <peda-piraten@won2.de>
%% Written 2013 by M G Berberich
%%
%% Diese Klasse stellt eine Umgebung zur Erstellung von Protokollen
%% der Vorstandssitzungen des Bezirksverbands Niederbayern bereit.
%%
%% Benötigt wird die Aller Schrift von:
%%     http://www.fontsquirrel.com/fonts/Aller
%%
%%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{protocoll}[2013/01/20 v1.0 Piraten-Protokoll-Klasse]

\ProcessOptions
\LoadClass[10pt,a4paper,DIV=19]{scrartcl}

\RequirePackage{fontspec}
\RequirePackage{xltxtra}
\RequirePackage{polyglossia}

\setdefaultlanguage[spelling=new]{german}

\RequirePackage{amsmath}
\RequirePackage{graphics}
\RequirePackage{framed}
\RequirePackage{color}
\RequirePackage{ifthen}
\RequirePackage{hyperref}
\RequirePackage{url}
\RequirePackage{calc}

\setmainfont{Aller} 
\setsansfont{Aller}
\newcommand\textlight[1]{{\fontspec{Aller Light}#1}}

\definecolor{orange}{RGB}{255,170,0}
\definecolor{lightorange}{RGB}{255,220,160}

\def\size@section{\Large\color{orange}}
\def\size@subsection{\large\color{orange}}

\newcommand{\Sitzungstermin}{?????}

%
% Allgemein
%

\newcommand{\Tätigkeit}[2]{\noindent{\leftskip 2cm%
  \llap{\hbox to 2cm{#1\hfil}}#2\par}\smallskip}

\parindent 0pt
\parskip 0.7ex

\renewcommand\UrlFont{\it}

%
% Überschrift
%

\setcounter{tocdepth}{2}
\newcommand{\Überschrift}{
  {\huge{\textbf{
    \begin{center}
      Protokoll der Sitzung des Niederbayerischen Bezirksvorstandes vom \Sitzungstermin
    \end{center}
  }}}
  \tableofcontents
  \vspace{1cm}
  \rule{\textwidth}{1pt}
}

%
% Teilnehmer
%

\newenvironment{Teilnehmer}[1]{\noindent\textbf{#1}}{\vspace{5mm}}
\newcommand{\person}{\newline\indent$\bullet$\;}
\newcommand{\Sitzungsleitung}[1]{\noindent\textbf{Sitzungsleitung:} #1\vspace{5mm}\newline}
\newcommand{\Zeit}[2]{\noindent\textbf{Beginn:} #1\newline\textbf{Ende:} #2}


%
% Anträge
%
\newcounter{antragsnr}\setcounter{antragsnr}{1}

\newdimen\antragsindent
\antragsindent1em
\newsavebox\antragbox
\newenvironment{Antrag}[4][\empty]{%
  \par\medskip\noindent%
  \ifthenelse{\equal{#1}{\empty}}
  {\textbf{#2}\phantomsection\addcontentsline{toc}{subsection}{\hspace{5mm}\arabic{antragsnr}\ #2}\refstepcounter{subsection}}
  {\textbf{#1}\phantomsection\addcontentsline{toc}{subsection}{\hspace{5mm}\arabic{antragsnr}\ #1}\refstepcounter{subsection}}
  \par\nobreak\noindent
  \colorbox{orange}{\parbox{\textwidth-2\fboxsep}{%
      \smallskip\textlight{Beschluss des Bezirksvorstand Niederbayern vom 
        \Sitzungstermin\quad\#\arabic{antragsnr}:}\\#2
      \smallskip}}\par\nobreak\noindent
  \begin{lrbox}\antragbox\begin{minipage}{\textwidth-2\fboxsep-2\antragsindent}%
      \vbox to 0pt{\noindent\hskip\textwidth
        \hbox to 0pt{\hss #3}\vss}%   
    } % Beginn
    {\smallskip\textbf{Ergebnis:} \Erg@bnis \ifdefined\Zus@tz\Zus@tz\let\Zus@tz\relax\fi%
    \end{minipage}\end{lrbox}%
  \colorbox{lightorange}{%
    \noindent\hskip\antragsindent
    \vbox{\hsize\wd\antragbox\vskip1ex\noindent\unhbox\antragbox\vskip1ex}%
    \hskip\antragsindent}%
  \addtocounter{antragsnr}{1}%
}% Ende

\newcommand{\Antragssteller}[2][\empty]{%
  Antragssteller: #2 \ifthenelse{\equal{#1}{\empty}}{}{(#1)}\\
}

\newcommand{\Unterstützer}[1]{Unterstützer: #1\\}

%\newenvironment{Text}{\rightskip25mm\textbf{Text:}\\}{\par\medskip}
\newenvironment{Text}{\dimen0\textwidth\advance\dimen0-2.5cm%
  \parshape=4 0pt \dimen0 0pt \dimen0 0pt \dimen0 0pt\textwidth
  \textbf{Text:}\\}{\par\medskip}
\newenvironment{Begründung}{\textbf{Begründung:}\\}{\par\medskip}

\newcommand{\ja}{\includegraphics[height=10pt]{yes}}
\newcommand{\nein}{\includegraphics[height=10pt]{no}}
\newcommand{\neutral}{\includegraphics[height=10pt]{neutral}}
\newcommand{\nichtda}{\includegraphics[height=10pt]{neutral}}

\newcommand{\antragsicon}[1]{\includegraphics[width=2cm]{#1}}
\newcommand{\ergebnis}[1]{\gdef\Erg@bnis{#1}}
\newcommand{\angenommen}{\antragsicon{angenommen}\ergebnis{Antrag angenommen}}
\newcommand{\abgelehnt}{\antragsicon{abgelehnt}\ergebnis{Antrag abgelehnt}}
\newcommand{\zurückgezogen}{\antragsicon{zurueckgezogen}\ergebnis{Antrag zurückgezogen}}
\newcommand{\vertagt}{\antragsicon{vertagt}\ergebnis{Antrag vertagt}}

\newcommand{\Abstimmung}[2]{\par\noindent #2~~#1\par\smallskip}

\newcommand{\Zusatzinfo}[1]{\def\Zus@tz{\par\noindent \textbf{Zusatzinfos:} #1}}
