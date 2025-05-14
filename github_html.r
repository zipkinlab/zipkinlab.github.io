## code to create html file for the lab front facing page

library(glue)
library(tidyverse)

dat <- read_csv("github_dat.csv")

id_codes <- c("icm", "dataintegration", "other", "community", "unmarked")
id_names <- c("Integrated community models", "Data integration models", "Other projects", "Community analyses", "Unmarked population models")

id_cd <- cbind(id_codes, id_names) %>% as_tibble()

this_id <- pull(dat[which(dat$data == "section"),2])

id <- paste0(gsub(" ", "",tolower(id_cd[which(id_cd$id_names == this_id),1])),
             dat[which(dat$data == "year"),2],
             toupper(substr(dat[which(dat$data == "author1"),2],1,1)))

citation <- dat[which(dat$data == "citation"),2]  %>% pull()

figure <- glue("assets/images/{citation}.png")
git_repo <- glue("https://github.com/zipkinlab/{citation}")
title <- pull(dat[which(dat$data == "title"),2])

FigSize <- function(OriginalWidth, OriginalHeight, OutputWidth = 200){
  WidthRatio <- OutputWidth / OriginalWidth
  OutputHeight <- OriginalHeight * WidthRatio
  #cat(paste0('Width = ', round(OutputWidth), '\nHeight = ', round(OutputHeight)))
  return(list(round(OutputWidth), round(OutputHeight)))
}

fig_height <- pull(dat[which(dat$data == "fig_height"),2]) %>% as.numeric()
fig_width <- pull(dat[which(dat$data == "fig_width"),2]) %>% as.numeric()

res_fig <- FigSize(OriginalWidth = fig_width, OriginalHeight = fig_height)

fig_width2 <- res_fig[[1]][1]
fig_height2 <- res_fig[[2]][1]

journal <- pull(dat[which(dat$data == "journal"),2])
year <- pull(dat[which(dat$data == "year"),2])

doi <- pull(dat[which(dat$data == "doi"),2])
doi_addr <- pull(dat[which(dat$data == "doi_addr"),2])

abstract <- pull(dat[which(dat$data == "abstract"),2])
numb_authors <- pull(dat[which(dat$data == "numb_authors"),2]) %>% as.numeric()

gitlink <- glue("https://github.com/zipkinlab/{citation}")

html_content1 <- glue_collapse(glue(" <h3 id='{id}'>{citation}</h3>
  <section class='example'>
    <section class='title'>
      <h1>{title}</h1>
      <img class='modal-img' src='{figure}' alt='{gsub('etal', 'et al.', gsub('_', ' ',citation))}' height='{fig_height2}' width='{fig_width2}' style='background-color:white;' >
        	<div class='modal' id='{gsub('etal', 'et al.', gsub('_', ' ',citation))}'>
		    <span class='close'>&times;</span>
		    <img class='modal-content'>
		    <div class='modal-caption'></div>
	      </div>
    </section>
    <section class='content'>
      <p>
<strong>Citation</strong> - "))


for(i in 1:numb_authors){
   
   author_loop <- glue("author{i}")
   assign(author_loop, as.character(glue("{pull(dat[which(dat$data == author_loop),2])}")))

   gitaut_loop <- glue("github{i}")
   assign(gitaut_loop, pull(dat[which(dat$data == gitaut_loop),2]))
   
   if (is.na(get(gitaut_loop))) {
        if (i == 1){ ht2 <- paste0(get(author_loop),", ")}
        if (i > 1 & i < numb_authors){ ht2 <- c(ht2, paste0(get(author_loop),", "))}
        if (i ==numb_authors){ ht2 <- c(ht2, paste0(get(author_loop),", "))}
        
            } else {

            if (i == 1){ ht2 <- paste0(" <a href='", get(gitaut_loop),"'>", get(author_loop),"</a>, ")}
            if (i > 1 & i < numb_authors){ ht2 <- c(ht2, paste0(" <a href='", get(gitaut_loop),"'>", get(author_loop),"</a>, "))}
            if (i ==numb_authors){ ht2 <- c(ht2, paste0("and <a href='", get(gitaut_loop),"'>", get(author_loop),"</a>"))} 
            }
}

html_content2 <- paste(ht2, collapse = "")

 html_content3 <- glue_collapse(glue("({year}) {title}. <em>{journal}</em>. <a href='{doi_addr}'>DOI: {doi}</a>
      </p>
      <p>
       <strong>Abstract</strong> - {abstract}
      </p>
      <p>
       <strong>Code and Data</strong> - <a href='{gitlink}'>Link to repo</a>
      </p>
    </section>
  </section>"))

html_content <- paste0(html_content1, html_content2, " ", html_content3)

## text
writeLines(html_content, "git_text.txt")

## title
html_title <- glue_collapse(glue("<em> <a href='#{id}'>{citation}</a></em> |"))
writeLines(html_title, "git_title.txt")
