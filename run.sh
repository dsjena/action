pwd
echo ${GITHUB_WORKSPACE}
ls ${GITHUB_WORKSPACE}

Rscript R/readData.R

Rscript -e 'rmarkdown::render("india/index.Rmd", output_format = "india/index.html")'
Rscript -e 'rmarkdown::render("india.Rmd")'
Rscript -e 'rmarkdown::render("world.rmd")'
