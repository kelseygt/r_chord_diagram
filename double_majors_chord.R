
# loading in packages/data
library(dplyr)
library(chorddiag)
library(htmlwidgets)
library(htmltools)
library(ggplot2)

# reading in data
dm <- read.csv(file.choose(), header = T)

# data wrangling for chord diagram
dm_grouped <- dm %>%
  subset(STUDENT_LEVEL == "UG" 
         & startsWith(DEGREE_CODE_1, "B") 
         & startsWith(DEGREE_CODE_2, "B"))
dm_grouped <- dm_grouped[!duplicated(dm_grouped[c("PIDM", "MAJOR_CODE_1", "MAJOR_CODE_2")]),]

dm1 <- unique(dm_grouped$MAJOR_DESC_1)
dm2 <- unique(dm_grouped$MAJOR_DESC_2)
distinct_majors <- data.frame(sort(unique(c(dm1, dm2))))
colnames(distinct_majors) <- c("majors")

# creating grouping colors based on college
colors <- rbind(select(dm, c("COLLEGE_CODE_1", "MAJOR_DESC_1")),
                setNames(select(dm, c("COLLEGE_CODE_2", "MAJOR_DESC_2")), 
                         names(select(dm, c("COLLEGE_CODE_1", "MAJOR_DESC_1"))))) %>%
  distinct() %>%
  mutate(COLOR = case_when(
    COLLEGE_CODE_1 == "BU" ~ "#DC8665",
    COLLEGE_CODE_1 == "HS" ~ "#534666",
    COLLEGE_CODE_1 == "PS" ~ "#534666",
    COLLEGE_CODE_1 == "LA" ~ "#138086",
    COLLEGE_CODE_1 == "ED" ~ "#CD7672",
    COLLEGE_CODE_1 == "SH" ~ "#EEB462",
    TRUE ~ "#FFF"
  )) %>%
  subset(select = -c(COLLEGE_CODE_1)) %>%
  rename("majors" = "MAJOR_DESC_1")

colors <- left_join(x = distinct_majors, y = colors, by = "majors")

# nrow of colors should equal nrow of distinct_majors, but it doesn't, because
# some majors are associated with different colleges -- need to address this

# creating final data set
chord_data <- distinct_majors
for (i in distinct_majors$majors) {
  y <- data.frame()
  for (j in distinct_majors$majors) {
    x <- sum(dm_grouped$MAJOR_DESC_1 == j & dm_grouped$MAJOR_DESC_2 == i)
    y <- rbind(y, x)
    colnames(y) <- c(i)
  }
  chord_data <- cbind(chord_data, y)
}

# chord diagram
m <- data.matrix(chord_data[, -1], rownames.force = NA)
dimnames(m) <- list(major_1 = distinct_majors$majors,
                    major_2 = distinct_majors$majors)
w <- chorddiag(m, 
               margin = 200, 
               groupnameFontsize = 11,
               groupColors = colors$COLOR,
               showTicks = FALSE)
w

saveWidget(w, "double_majors_chord_diagram.html")
