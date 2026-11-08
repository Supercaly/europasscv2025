% europassletter2025.cls
% An A4 cover-letter class with a layout inspired by the Europass editor.
%
% This work may be distributed and/or modified under the conditions of
% the LaTeX Project Public License, either version 1.3 of this license
% or (at your option) any later version.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{europassletter2025}[2026/11/08 Europass cover letter class]

\newcommand{\ecl@language}{english}
\newcommand{\ecl@colorscheme}{default}

\DeclareOption{english}{\renewcommand{\ecl@language}{english}}
\DeclareOption{german}{\renewcommand{\ecl@language}{german}}
\DeclareOption{hungarian}{\renewcommand{\ecl@language}{hungarian}}
\DeclareOption{italian}{\renewcommand{\ecl@language}{italian}}
\DeclareOption{romanian}{\renewcommand{\ecl@language}{romanian}}

\DeclareOption{color-default}{\renewcommand{\ecl@colorscheme}{default}}
\DeclareOption{color-darkblue}{\renewcommand{\ecl@colorscheme}{darkblue}}
\DeclareOption{color-blue}{\renewcommand{\ecl@colorscheme}{blue}}
\DeclareOption{color-darkgreen}{\renewcommand{\ecl@colorscheme}{darkgreen}}
\DeclareOption{color-green}{\renewcommand{\ecl@colorscheme}{green}}
\DeclareOption{color-darkviolet}{\renewcommand{\ecl@colorscheme}{darkviolet}}
\DeclareOption{color-violet}{\renewcommand{\ecl@colorscheme}{violet}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[12pt]{article}
\RequirePackage{europasscv2025-common}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{xparse}
\RequirePackage{fontawesome5}
\RequirePackage[hidelinks]{hyperref}

\geometry{
  a4paper,
  left=12mm,
  right=12mm,
  top=16mm,
  bottom=12mm,
  noheadfoot
}

\InputIfFileExists{colors/ecv_\ecl@colorscheme.def}{}{%
  \ClassWarning{europassletter2025}{Color scheme `\ecl@colorscheme' not found; using default}%
  \input{colors/ecv_default.def}%
}
\InputIfFileExists{locale/ecv_\ecl@language.def}{}{%
  \ClassWarning{europassletter2025}{Language file `\ecl@language' not found; using English}%
  \input{locale/ecv_english.def}%
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\pagestyle{empty}

\newlength{\ecl@bandheight}
\newlength{\ecl@smallgap}
\newlength{\ecl@blockgap}
\setlength{\ecl@bandheight}{8mm}
\setlength{\ecl@smallgap}{3mm}
\setlength{\ecl@blockgap}{6mm}

\makeatletter

\newcommand{\ecl@heavy}{\fontseries{eb}\selectfont}

% Sender information.
\let\ecl@sendername\@empty
\let\ecl@senderaddress\@empty
\let\ecl@senderemail\@empty
\let\ecl@senderphone\@empty
\newcommand{\ecl@phonetype}{mobile}
\newcommand{\ecl@messengericon}{\faComments}
\let\ecl@messengerplatform\@empty
\let\ecl@messengerhandle\@empty

\newcommand{\eclname}[1]{\gdef\ecl@sendername{#1}}
\newcommand{\ecladdress}[1]{\gdef\ecl@senderaddress{#1}}
\newcommand{\eclemail}[1]{\gdef\ecl@senderemail{#1}}
\newcommand{\ecl@phoneicon@home}{\faIcon{home}}
\newcommand{\ecl@phoneicon@mobile}{\faIcon{mobile-alt}}
\newcommand{\ecl@phoneicon@work}{\faIcon{briefcase}}
\newcommand{\ecl@phoneicon@other}{\faIcon{phone-alt}}
\newcommand{\eclphone}[2][mobile]{%
  \gdef\ecl@senderphone{#2}%
  \@ifundefined{ecl@phoneicon@#1}{%
    \ClassWarning{europassletter2025}{Unknown phone type `#1'; using mobile}%
    \gdef\ecl@phonetype{mobile}%
  }{%
    \gdef\ecl@phonetype{#1}%
  }%
}
\NewDocumentCommand{\eclim}{O{\faComments} m m}{%
  \gdef\ecl@messengericon{#1}%
  \gdef\ecl@messengerplatform{#2}%
  \gdef\ecl@messengerhandle{#3}%
}

% Recipient and letter information.
\let\ecl@recipientname\@empty
\let\ecl@recipientorganization\@empty
\let\ecl@recipientaddress\@empty
\let\ecl@date\@empty
\let\ecl@subject\@empty
\let\ecl@opening\@empty
\let\ecl@closing\@empty
\let\ecl@signature\@empty
\let\ecl@signatureimage\@empty
\newcommand{\ecl@signatureimageheight}{25mm}

\newcommand{\eclrecipientname}[1]{\gdef\ecl@recipientname{#1}}
\newcommand{\eclrecipientorganization}[1]{\gdef\ecl@recipientorganization{#1}}
\newcommand{\eclrecipientaddress}[1]{\gdef\ecl@recipientaddress{#1}}
\newcommand{\ecldate}[1]{\gdef\ecl@date{#1}}
\newcommand{\eclsubject}[1]{\gdef\ecl@subject{#1}}
\newcommand{\eclopening}[1]{\gdef\ecl@opening{#1}}
\newcommand{\eclclosing}[1]{\gdef\ecl@closing{#1}}
\newcommand{\eclsignature}[1]{\gdef\ecl@signature{#1}}
\newcommand{\eclsignatureimage}[2][25mm]{%
  \gdef\ecl@signatureimage{#2}%
  \gdef\ecl@signatureimageheight{#1}%
}

\newcommand{\ecl@contacticon}[1]{%
  \makebox[1em][c]{\color{ecv@color@section}#1}%
}
\newcommand{\ecl@contactseparator}{%
  \quad{\color{ecv@color@text}|}\quad
}
\newcommand{\ecl@contactfield}[3]{%
  \ifx#1\@empty\else
    \ecl@nextcontactseparator
    \ecl@contacticon{#2}\quad#3%
    \let\ecl@nextcontactseparator\ecl@contactseparator
  \fi
}
\newcommand{\ecl@optionalparagraph}[1]{%
  \ifx#1\@empty\else #1\par\fi
}

\newcommand{\ecl@header}{%
  {\fontsize{16pt}{20pt}\selectfont
   \ecl@heavy\color{ecv@color@highlight}%
   \MakeUppercase{\ecl@sendername}\par}%
  \vspace{\ecl@smallgap}%
  {\fontsize{10pt}{12pt}\selectfont\raggedright
   \ifx\ecl@senderaddress\@empty\else
     \noindent\ecl@contacticon{\faIcon{map-marker-alt}}\quad
     \ecl@senderaddress\par
   \fi
   % Keep the contact details on one shared baseline, as in the original class.
   \setbox\@tempboxa\hbox{%
     \let\ecl@nextcontactseparator\@empty
     \ecl@contactfield\ecl@senderemail{\faIcon{envelope}}{%
       \href{mailto:\ecl@senderemail}{\underline{\ecl@senderemail}}}%
     \ecl@contactfield\ecl@senderphone{%
       \csname ecl@phoneicon@\ecl@phonetype\endcsname}{\ecl@senderphone}%
     \ecl@contactfield\ecl@messengerplatform{\ecl@messengericon}{%
       \ecl@messengerplatform:~\ecl@messengerhandle}%
   }%
   \ifdim\wd\@tempboxa>\z@
     \ifx\ecl@senderaddress\@empty\else
       \vspace{\ecl@smallgap}%
     \fi
     \noindent\box\@tempboxa\par
   \fi
  }%
  \vspace{\ecl@smallgap}%
  {\color{ecv@color@section}\hrule height 1.5pt\relax}%
  \vspace{\ecl@blockgap}%
  {\ecl@heavy\color{ecv@color@section}\ecv@label@recipient:}%
  \enspace\ecl@recipientname\par
  \ecl@optionalparagraph\ecl@recipientorganization
  \ecl@optionalparagraph\ecl@recipientaddress
  \vspace{\ecl@blockgap}%
  \ecl@optionalparagraph\ecl@date
  \vspace{\ecl@smallgap}%
  \ifx\ecl@subject\@empty\else
    {\ecl@heavy\color{ecv@color@section}\ecv@label@subject:}%
    \enspace\ecl@subject\par
  \fi
  \nobreak\vspace{\ecl@blockgap}%
}

\AddToHook{shipout/background}{%
  \begin{tikzpicture}[remember picture,overlay]
    \fill[ecv@color@accent]
      (current page.north west)
      rectangle ([yshift=-\ecl@bandheight]current page.north east);
    \fill[ecv@color@accent]
      ([yshift=\ecl@bandheight]current page.south west)
      rectangle (current page.south east);
  \end{tikzpicture}%
}

\newenvironment{eclletter}{%
  \par
  \fontsize{12pt}{18pt}\selectfont
  \color{ecv@color@text}%
  \setlength{\parskip}{0pt}%
  \ecl@header
  \ecl@optionalparagraph\ecl@opening
  \setlength{\parskip}{\ecl@smallgap}%
  \ignorespaces
}{%
  \par
  \setlength{\parskip}{0pt}%
  \vspace{\ecl@blockgap}%
  \ecl@optionalparagraph\ecl@closing
  \nobreak\vspace{\ecl@smallgap}%
  \ifx\ecl@signatureimage\@empty\else
    \includegraphics[height=\ecl@signatureimageheight,keepaspectratio]{%
      \ecl@signatureimage}\par
  \fi
  \ecl@optionalparagraph\ecl@signature
  \ignorespacesafterend
}

\makeatother
