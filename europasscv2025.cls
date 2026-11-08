% europasscv2025.cls
% An unofficial LaTeX class for the Europass CV (2025 "classic" template)
%
% Copyright 2025 Lorenzo Calisti
%
% This work may be distributed and/or modified under the conditions of
% the LaTeX Project Public License, either version 1.3 of this license
% or (at your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2008 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Lorenzo Calisti.
%
% COMPATIBILITY:
%   This class works with pdfLaTeX, XeLaTeX, and LuaLaTeX.
%   The engine is auto-detected; no changes needed.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{europasscv2025}[2026-05-20 Europass CV class (2025 classic template)]

% ============================================================
% EARLY PACKAGES (safe before LoadClass)
% ============================================================
\RequirePackage{etoolbox}

% ============================================================
% CLASS OPTIONS
% ============================================================

% Debug mode
\newif\ifecv@debug\ecv@debugfalse
\DeclareOption{debug}{\ecv@debugtrue}

% Europass logo
\newif\ifecv@nologo\ecv@nologofalse
\DeclareOption{nologo}{\ecv@nologotrue}

% Page number on the footer
\newif\ifecv@nototpages\ecv@nototpagesfalse
\DeclareOption{nototpages}{\ecv@nototpagestrue}

% Language
\newcommand{\ecv@lang}{english}% Default to english
\DeclareOption{english}{\renewcommand{\ecv@lang}{english}}
\DeclareOption{german}{\renewcommand{\ecv@lang}{german}}
\DeclareOption{ngerman}{\renewcommand{\ecv@lang}{ngerman}}
\DeclareOption{hungarian}{\renewcommand{\ecv@lang}{hungarian}}
\DeclareOption{italian}{\renewcommand{\ecv@lang}{italian}}
\DeclareOption{romanian}{\renewcommand{\ecv@lang}{romanian}}

% Color schemes
\newcommand{\ecv@colorscheme}{default}% Default color scheme
\DeclareOption{color-default}{\renewcommand{\ecv@colorscheme}{default}}
\DeclareOption{color-darkblue}{\renewcommand{\ecv@colorscheme}{darkblue}}
\DeclareOption{color-blue}{\renewcommand{\ecv@colorscheme}{blue}}
\DeclareOption{color-darkgreen}{\renewcommand{\ecv@colorscheme}{darkgreen}}
\DeclareOption{color-green}{\renewcommand{\ecv@colorscheme}{green}}
\DeclareOption{color-darkviolet}{\renewcommand{\ecv@colorscheme}{darkviolet}}
\DeclareOption{color-violet}{\renewcommand{\ecv@colorscheme}{violet}}

% Pass remaining options to the base class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[a4paper]{article}
\RequirePackage{europasscv2025-common}

% ============================================================
% PACKAGES (loaded after LoadClass so dimensions are set)
% ============================================================
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{tikz}
\RequirePackage{ragged2e}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{colortbl}
\RequirePackage{longtable}
\RequirePackage[expansion=false]{microtype}
\RequirePackage{pgfkeys}
\RequirePackage[normalem]{ulem}
\RequirePackage{tcolorbox}
\RequirePackage{xparse}
\ifecv@debug \RequirePackage{showframe} \fi

% ============================================================
% LOAD LANGUAGE LABELS AND SET DOCUMENT LANGUAGE
% ============================================================
\InputIfFileExists{locale/\ecv@lang.def}{}{%
    \PackageWarning{europasscv2025}{Language file '\ecv@lang.def' not found, falling back to english}%
    \renewcommand{\ecv@lang}{english}%
    \input{locale/english.def}%
}
\ecv@setlanguage{\ecv@lang}

% hyperref needs to be the last loaded package
\RequirePackage{hyperref}

\hypersetup{
  colorlinks=true,
  allcolors=ecv@color@link
}

% ============================================================
% PAGE GEOMETRY
% ============================================================
\newlength{\ecv@margin@top}
\newlength{\ecv@margin@bottom}
\newlength{\ecv@margin@left}
\newlength{\ecv@margin@right}

\setlength{\ecv@margin@top}{10mm}
\setlength{\ecv@margin@bottom}{10mm}
\setlength{\ecv@margin@left}{14mm}
\setlength{\ecv@margin@right}{14mm}

\geometry{
  paper=a4paper,
  left=\ecv@margin@left,
  right=\ecv@margin@right,
  top=\ecv@margin@top,
  bottom=\ecv@margin@bottom,
  includefoot=true
}

% ============================================================
% LOAD COLORS SCHEMES
% ============================================================
\InputIfFileExists{colors/ecv_\ecv@colorscheme.def}{}{%
    \PackageWarning{europasscv2025}{Color file 'ecv_\ecv@colorscheme.def' not found, falling back to default}%
    \input{colors/ecv_default.def}%
}

% ============================================================
% PAGE STYLE (footer with logo + page number)
% ============================================================
\fancypagestyle{ecv@footer}{%
    \fancyhf{}%
    \renewcommand{\headrulewidth}{0pt}%
    \fancyfoot[R]{%
        \ifecv@nologo\else%
            % Europass logo
            \raisebox{-0.20\height}{%
                \includegraphics[height=4mm]{europass_logo.pdf}%
            }%
            \hspace{0.5em}%
            \fi%
        \ifecv@nototpages\else%
            {%
                \color{ecv@color@text}%
                Page~\thepage/\pageref*{LastPage}%
            }
            \normalcolor
        \fi%
    }%
}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\renewcommand{\normalcolor}{\color{ecv@color@text}}
\AtBeginDocument{\pagestyle{ecv@footer}}

% ============================================================
% HELPER FUNCTIONS
% ============================================================
% Adds a ' | ' text separator that can be broken to a new line
\newcommand{\ecv@sep}{%
    \allowbreak\space\textbar\space\allowbreak%
}

% Adds an url with underline
\newcommand{\ecv@url}[2][ecv@color@link]{%
    \begingroup%
        \hypersetup{allcolors=#1}%
        \href{#2}{\uline{#2}}%
    \endgroup%
}

% ============================================================
% USER PHOTO
% ============================================================
\newlength{\ecv@photosize}
\setlength{\ecv@photosize}{3.5cm} 

\newif\ifecv@photo\ecv@photofalse
\newcommand{\ecv@photo}{}
\newcommand{\ecvphoto}[1]{\ecv@phototrue\renewcommand{\ecv@photo}{#1}}

% ============================================================
% PERSONAL INFO
% ============================================================
\newcommand{\ecv@info@name}{}
\newcommand{\ecv@info@dob}{}
\newcommand{\ecv@info@gender}{}
\newcommand{\ecv@info@nationalitylist}{}
\newcommand{\ecv@info@addresslist}{}
\newcommand{\ecv@info@phonelist}{}
\newcommand{\ecv@info@emaillist}{}
\newcommand{\ecv@info@websitelist}{}
\newcommand{\ecv@info@sociallist}{}
\newcommand{\ecv@info@imlist}{}

\newcommand{\ecvname}[1]{\renewcommand{\ecv@info@name}{#1}}%
\newcommand{\ecvdateofbirth}[1]{\renewcommand{\ecv@info@dob}{#1}}%
\newcommand{\ecvgender}[1]{\renewcommand{\ecv@info@gender}{#1}}%
\newcommand{\ecvnationality}[1]{%
    \ifdefempty{\ecv@info@nationalitylist}{%
        \renewcommand{\ecv@info@nationalitylist}{#1}%
    }{%
        \gappto{\ecv@info@nationalitylist}{,\ #1}%
    }%
}%
\newcommand{\ecvaddress}[2][\ecv@label@home]{%
    \ifdefempty{\ecv@info@addresslist}{%
        \renewcommand{\ecv@info@addresslist}{#2\ (#1)}%
    }{%
        \gappto{\ecv@info@addresslist}{,\ #2\ (#1)}%
    }%
}%
\newcommand{\ecvphone}[2][\ecv@label@mobile]{%
    \ifdefempty{\ecv@info@phonelist}{%
        \renewcommand{\ecv@info@phonelist}{#2\ (#1)}%
    }{%
        \gappto{\ecv@info@phonelist}{,\ #2\ (#1)}%
    }%
}%
\newcommand{\ecvemail}[1]{%
    \ifdefempty{\ecv@info@emaillist}{%
        \renewcommand{\ecv@info@emaillist}{\ecv@url[ecv@color@infolink]{#1}}%
    }{%
        \gappto{\ecv@info@emaillist}{,\ \ecv@url[ecv@color@infolink]{#1}}%
    }%
}%
\newcommand{\ecvwebsite}[1]{%
    \ifdefempty{\ecv@info@websitelist}{%
        \renewcommand{\ecv@info@websitelist}{\ecv@url[ecv@color@infolink]{#1}}%
    }{%
        \gappto{\ecv@info@websitelist}{,\ \ecv@url[ecv@color@infolink]{#1}}%
    }%
}%
\newcommand{\ecvsocial}[2]{%
    \ifdefempty{\ecv@info@sociallist}{%
        \renewcommand{\ecv@info@sociallist}{#1:~\ecv@url[ecv@color@infolink]{#2}}%
    }{%
        \gappto{\ecv@info@sociallist}{\ #1:~\ecv@url[ecv@color@infolink]{#2}}%
    }%
}%
\newcommand{\ecvim}[2]{%
    \ifdefempty{\ecv@info@imlist}{%
        \renewcommand{\ecv@info@imlist}{#1:~#2}%
    }{%
        \gappto{\ecv@info@imlist}{\ #1:~#2}%
    }%
}%

% ------------------------------------------------------------
% List with personal info
% ------------------------------------------------------------
\newcommand{\ecv@personalinfolist}{}
\newcommand{\ecv@personalinfolist@append}[1]{%
    \ifdefempty{\ecv@personalinfolist}{%
        \renewcommand{\ecv@personalinfolist}{#1}%
    }{%
        \gappto{\ecv@personalinfolist}{\ecv@sep#1}%
    }%
}
\newcommand{\ecv@makepersonalinfolist}{%
    % Create list of personal info displayed in the header
    %
    % Date of birth
    \ifdefempty{\ecv@info@dob}{}{%
        \ecv@personalinfolist@append{\ecv@label@dob:~\ecv@info@dob}%
    }%
    % Gender
    \ifdefempty{\ecv@info@gender}{}{%
        \ecv@personalinfolist@append{\ecv@label@gender:~\ecv@info@gender}%
    }%
    % Nationalities
    \ifdefempty{\ecv@info@nationalitylist}{}{%
        \ecv@personalinfolist@append{\ecv@label@nationality:~\ecv@info@nationalitylist}%
    }%
    % Phone numbers
    \ifdefempty{\ecv@info@phonelist}{}{%
        \ecv@personalinfolist@append{\ecv@label@phone:~\ecv@info@phonelist}%
    }%
    % Email address
    \ifdefempty{\ecv@info@emaillist}{}{%
        \ecv@personalinfolist@append{\ecv@label@email:~\ecv@info@emaillist}%
    }%
    % Personal Websites
    \ifdefempty{\ecv@info@websitelist}{}{%
        \ecv@personalinfolist@append{\ecv@label@website:~\ecv@info@websitelist}%
    }%
    % Social media
    \ifdefempty{\ecv@info@sociallist}{}{%
        \ecv@personalinfolist@append{\ecv@info@sociallist}%
    }%
    % Address
    \ifdefempty{\ecv@info@addresslist}{}{%
        \ecv@personalinfolist@append{\ecv@label@address:~\ecv@info@addresslist}%
    }%
}

% ------------------------------------------------------------
% Personal info content widget
% -----------------------------------------------------------
\newcommand{\ecv@personalinfo@content}{%
    % Name
    \ifdefempty{\ecv@info@name}{}{%
        {%
            \color{ecv@color@title}%
            \LARGE\textbf{\ecv@info@name}\par\vspace{8pt}%
        }\normalcolor%
    }%
    {%
        \color{ecv@color@info}%
        \ecv@personalinfolist%
    }\normalcolor%
}

% ------------------------------------------------------------
% User photo widget
% ------------------------------------------------------------
\newcommand{\ecv@photo@content}{%
    \begin{tikzpicture}%
        \clip (0,0) circle (0.5\ecv@photosize);%
        \node [anchor=center] at (0,0) {%
            \includegraphics[%
                width=\ecv@photosize,%
                height=\ecv@photosize,%
                keepaspectratio=false%
            ]{\ecv@photo}%
        };%
        \draw[%
            color=ecv@color@accent,%
            line width=1pt%
        ] (0,0) circle (\dimexpr0.5\ecv@photosize-1pt);%
        \draw[%
            color=ecv@color@border,%
            line width=2pt%
        ] (0,0) circle (0.5\ecv@photosize);%
    \end{tikzpicture}%
}

% ------------------------------------------------------------
% Header content widget
% ------------------------------------------------------------
\newsavebox{\ecv@headerbox}%
\newlength{\ecv@header@height}%
\newlength{\ecv@header@contentwidth}%
\newlength{\ecv@header@contentheight}%
\newlength{\ecv@header@textheight}%

\newcommand{\ecv@header@content}{%
    % -----------------------------------------------------
    % Compute content width
    % -----------------------------------------------------
    \setlength{\ecv@header@contentwidth}{%
        \dimexpr\paperwidth-\ecv@margin@left-\ecv@margin@right\relax%
    }%
    \ifecv@photo%
        \addtolength{\ecv@header@contentwidth}{-\ecv@photosize}%
        \addtolength{\ecv@header@contentwidth}{-0.8cm}% Space between photo and info
    \fi%
    % -----------------------------------------------------
    % Measure text content height
    % -----------------------------------------------------
    \savebox{\ecv@headerbox}{%
        \parbox[t]{\ecv@header@contentwidth}{%
            \RaggedRight%
            \ecv@personalinfo@content%
        }%
    }%
    \setlength{\ecv@header@contentheight}{%
        \dimexpr\ht\ecv@headerbox+\dp\ecv@headerbox\relax%
    }%
    % -----------------------------------------------------
    % Header height
    % -----------------------------------------------------
    \ifecv@photo%
        % Photo and personal info
        \setlength{\ecv@header@height}{%
            \dimexpr%
            1cm%top padding
            +\ecv@photosize%
            +0.5cm%bottom padding
            \relax%
        }%
        % Personal info + its paddings
        \setlength{\ecv@header@textheight}{%
            \dimexpr%
            1.5cm%
            +\ecv@header@contentheight%
            +0.5cm%
            \relax%
        }%
        % Take the maximum between photo + paddings and info + padding
        \ifdim\ecv@header@textheight>\ecv@header@height%
            \setlength{\ecv@header@height}{\ecv@header@textheight}%
        \fi%
    \else%
        % No photo, only personal info
        \setlength{\ecv@header@height}{%
            \dimexpr%
            1.5cm% top text padding
            + \ecv@header@contentheight%
            + 0.5cm% bottom padding
            \relax%
        }%
    \fi%
    % -----------------------------------------------------
    % Reserve vertical space
    % -----------------------------------------------------
    \noindent\vspace*{%
        \dimexpr%
            \ecv@header@height% header
            -\ecv@margin@top% top margin
            -\baselineskip% text baseline
        \relax%
    }%
    % -----------------------------------------------------
    % Draw header
    % -----------------------------------------------------
    \begin{tikzpicture}[remember picture, overlay, baseline=0pt]%
        \useasboundingbox (0,0);%
        % -------------------------------------------------
        % Background
        % -------------------------------------------------
        \fill[ecv@color@accent]%
            ([yshift=-\ecv@header@height] current page.north west)%
            rectangle%
            (current page.north east);%
        % -------------------------------------------------
        % Photo
        % -------------------------------------------------
        \ifecv@photo%
            \node[anchor=north west] 
            at (%
                [xshift=\ecv@margin@left,%
                yshift=-\ecv@margin@top]%
                current page.north west%
            ) {\ecv@photo@content};%
        \fi%
        % -------------------------------------------------
        % Text content
        % -------------------------------------------------
        \node[%
            anchor=north west,%
            inner sep=0pt,%
            outer sep=0pt,%
        ]%
        at ([xshift=\dimexpr%
            \ecv@margin@left%
            + \ifecv@photo%
                \ecv@photosize+0.8cm%Photo + spacing
            \else%
                +0pt%
            \fi%
            \relax,%
            yshift=-15mm]%
            current page.north west%
        )%
        {%
            \begin{minipage}{\ecv@header@contentwidth}%
                \RaggedRight%
                \ecv@personalinfo@content%
            \end{minipage}%
        };%
    \end{tikzpicture}%
    \ignorespaces%
}

\newenvironment{ecvinfo}{%
    % Reset environment variables
    \renewcommand{\ecv@info@name}{}
    \renewcommand{\ecv@info@dob}{}
    \renewcommand{\ecv@info@gender}{}
    \renewcommand{\ecv@info@nationalitylist}{}
    \renewcommand{\ecv@info@addresslist}{}
    \renewcommand{\ecv@info@phonelist}{}
    \renewcommand{\ecv@info@emaillist}{}
    \renewcommand{\ecv@info@websitelist}{}
    \renewcommand{\ecv@info@sociallist}{}
    \renewcommand{\ecv@info@imlist}{}
    \renewcommand{\ecv@personalinfolist}{}
}{%
    % Make list with personal info
    \ecv@makepersonalinfolist%
    % Display header
    \ecv@header@content%
}

% ============================================================
% SECTIONS
% ============================================================
% \ecvsection{title}
% Bold small label + full-width rule below
\newcommand{\ecvsection}[1]{%
    \par\vspace{12pt}%
    \noindent{%
        {%
            \color{ecv@color@section}%
            \footnotesize\textbf{#1}%
            \hspace{4pt}%
            \leaders\hbox{%
                \raisebox{0.5ex}{\rule{1pt}{0.5pt}}%
            }\hfill\kern0pt%
        }%
    }\par%
    \normalcolor%
    \ignorespaces%
}

% ============================================================
% SECTION ENTRY
% ============================================================
\pgfkeys{
    /ecv/entry/.is family,
    /ecv/entry/.cd,
    title/.store in=\ecv@entry@title,
    organization/.store in=\ecv@entry@org,
    date/.store in=\ecv@entry@date,
    location/.store in=\ecv@entry@location,
    description/.store in=\ecv@entry@desc,
    link/.store in=\ecv@entry@link
}
\NewDocumentCommand{\ecventry}{s m}{%
    % Reset values
    \pgfkeys{/ecv/entry/.cd,
        title={},
        organization={},
        date={},
        location={},
        description={},
        link={}
    }%

    % Parse input
    \pgfkeys{/ecv/entry/.cd,#2}%

    \vspace{8pt}
    \noindent
    {%
        \color{ecv@color@highlight}
        \textbf{\ecv@entry@title}%
        \ifdefempty{\ecv@entry@org}{}{\ecv@sep\ecv@entry@org}%
        \IfBooleanTF{#1}{%
            \ifdefempty{\ecv@entry@date}{}{\ecv@sep\ecv@entry@date}%
            \ifdefempty{\ecv@entry@location}{}{\ecv@sep\ecv@entry@location}%
        }{%
            \normalcolor%
            \ifdefempty{\ecv@entry@date}{}{\footnotesize\ecv@sep\ecv@entry@date}%
            \ifdefempty{\ecv@entry@location}{}{\footnotesize\ecv@sep\ecv@entry@location}%
        }%
        \normalcolor%
    }\par%
    \ifdefempty{\ecv@entry@desc}{}{%
        \vspace{4pt}
        {\IfBooleanTF{#1}{\footnotesize}{}\ecv@entry@desc}\par%
    }%
    \ifdefempty{\ecv@entry@link}{}{%
        \vspace{6pt}%
        \ecv@url{\ecv@entry@link}\par%
    }%
    \ignorespaces%
}

% ============================================================
% LANGUAGE SKILLS TABLE
% ============================================================
% Internal storage for language lists
\newcommand{\ecv@mtlist}{}
\newcommand{\ecv@langrows}{}
\newif\ifecv@cefrlevels\ecv@cefrlevelsfalse
\newcommand{\ecvcefrlevels}{\ecv@cefrlevelstrue}

% Set row length and spacing
\renewcommand{\arraystretch}{2}
\newlength{\ecv@langrowsep}
\setlength{\ecv@langrowsep}{\dimexpr((\baselineskip * \arraystretch) - 2mm)}

\newcommand{\ecvmothertongue}[1]{%
    \ifdefempty{\ecv@mtlist}{%
        \renewcommand{\ecv@mtlist}{#1}%
    }{%
        \gappto{\ecv@mtlist}{\ecv@sep#1}%
    }%
}

\newcommand{\ecv@languagerow}[6]{%
    \rowcolor{ecv@color@accent}%
    \textcolor{ecv@color@tableitem}{\textbf{#1}} &%
    \textcolor{ecv@color@tableitem}{#2} &%
    \textcolor{ecv@color@tableitem}{#3} &%
    \textcolor{ecv@color@tableitem}{#4} &%
    \textcolor{ecv@color@tableitem}{#5} &%
    \textcolor{ecv@color@tableitem}{#6} \\%
}

\newcommand{\ecvlanguage}[6]{%
    \ifdefempty{\ecv@langrows}{%
        \renewcommand{\ecv@langrows}{\ecv@languagerow{#1}{#2}{#3}{#4}{#5}{#6}}%
    }{%
        \gappto{\ecv@langrows}{%
            & & & & & \\[-\ecv@langrowsep]%
            \ecv@languagerow{#1}{#2}{#3}{#4}{#5}{#6}%
        }%
    }%
}

\newenvironment{ecvlanguages}{%
    % Reset language lists
    \renewcommand{\ecv@mtlist}{}%
    \renewcommand{\ecv@langrows}{}%
    \ecv@cefrlevelsfalse%
}{%
    % ==== Mother Tongues ====
    \par\vspace{6pt}
    {%
        \color{ecv@color@highlight}%
        \small\ecv@label@mothertongue: \textbf{\ecv@mtlist}%
    }\normalcolor%
    \par\vspace{6pt}

    % ==== Other languages ====
    \arrayrulecolor{ecv@color@tablesep}%
    \begin{tabularx}{\linewidth}{%
        >{\raggedright\arraybackslash}p{3cm}%  Language name
        |%
        >{\centering\arraybackslash}X%    Understanding - Listening
        >{\centering\arraybackslash}X%    Understanding - Reading
        |%
        >{\centering\arraybackslash}X%    Speaking - Prod.
        >{\centering\arraybackslash}X%    Speaking - Int.
        |%
        >{\centering\arraybackslash}p{3cm}%    Writing
        }%
        % ==== HEADER ====
        & \multicolumn{2}{c|}{\textbf{\ecv@label@understanding}} & \multicolumn{2}{c|}{\textbf{\ecv@label@speaking}} & \textbf{\ecv@label@writing} \\
        & \footnotesize{\ecv@label@listening} & \footnotesize{\ecv@label@reading} & \footnotesize{\ecv@label@spokenproduction} & \footnotesize{\ecv@label@spokeninteraction} & \\
        
        % ==== ROWS ====
        \ecv@langrows%
    \end{tabularx}\par%
    % ==== Language proficency lavel
    \ifecv@cefrlevels
        \vspace{16pt}
        \footnotesize\textit{\ecv@label@cefrlevels}
    \fi
}

% ============================================================
% PERSONAL SKILLS
% ============================================================
% Internal storage for skills
\newcommand{\ecv@skillstitle}{}
\newcommand{\ecv@skillslist}{}

\newcommand{\ecvskill}[1]{%
    \ifdefempty{\ecv@skillslist}{%
        \renewcommand{\ecv@skillslist}{#1}%
    }{%
        \gappto{\ecv@skillslist}{\ecv@sep#1}%
    }%
}

\newenvironment{ecvskills}[1][]{%
    \renewcommand{\ecv@skillslist}{}%
    \renewcommand{\ecv@skillstitle}{#1}%
    }{%
    \vspace{8pt}%
    \noindent%
    \ifdefempty{\ecv@skillstitle}{}{%
        \textbf{\ecv@skillstitle}%
        \color{ecv@color@highlight}%
        \ecv@sep%
    }%
    {%
        \color{ecv@color@highlight}%
        \ecv@skillslist%
    }\normalcolor%
    \par%
}

% ============================================================
% DRIVING LICENCES
% ============================================================
% Internal storage for licences
\newcommand{\ecv@licenceslist}{}

\newcommand{\ecv@drivinglicenceitem}[1]{%
    \vspace{8pt}%
    \noindent%
    \textbf{\ecv@label@drivinglicence~#1}%
    \par%
}

\newcommand{\ecvdrivinglicence}[1]{%
    \ifdefempty{\ecv@licenceslist}{%
        \renewcommand{\ecv@licenceslist}{\ecv@drivinglicenceitem{#1}}%
    }{%
        \gappto{\ecv@licenceslist}{\ecv@drivinglicenceitem{#1}}%
    }%
}

\newenvironment{ecvdrivinglicences}[1][]{%
    \renewcommand{\ecv@licenceslist}{}%
}{%
    {%
        \color{ecv@color@highlight}%
        \ecv@licenceslist%
    }\normalcolor%
}
