pwd
echo ${GITHUB_WORKSPACE}
ls ${GITHUB_WORKSPACE}

Rscript R/readData.R

Rscript -e 'rmarkdown::render("india/index.Rmd", output_format = "india/index.html")'
