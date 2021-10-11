# loading in packages/data

library(chorddiag)
library(htmlwidgets)
library(htmltools)

double <- read.csv(file.choose(), header = T)
colors <- read.csv(file.choose(), header = T) # colors based on college

# data wrangling

dm1 <- unique(double$major_1)
dm2 <- unique(double$major_2)
distinct_majors <- data.frame(sort(unique(c(dm1, dm2))))
colnames(distinct_majors) <- c("majors")

nrow(distinct_majors) # these should be equal in length, and sorted the same
nrow(colors)


chord_data <- distinct_majors
for (i in distinct_majors$majors) {
  y <- data.frame()
  for (j in distinct_majors$majors) {
    x <- sum(double$major_1 == j & double$major_2 == i)
    y <- rbind(y, x)
    colnames(y) <- c(i)
  }
  chord_data <- cbind(chord_data, y)
}


# diagram

m <- data.matrix(chord_data[, -1], rownames.force = NA)
dimnames(m) <- list(major_1 = distinct_majors$majors,
                    major_2 = distinct_majors$majors)

w <- chorddiag(m, margin = 300, groupnameFontsize = 15,
               groupColors = colors$color,
               showTicks = FALSE, ticklabelFontsize = 8)
w

saveWidget(w, "double_majors_chord_diagram.html")