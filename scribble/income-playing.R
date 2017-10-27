# playing around with a range of datasets with "Income" in their name
# Peter Ellis, 27 October 2017

library(datagovau)

income_md <- search_data("name:income", limit = 1000)

# 269 datasets about income
dim(income_md)

sort(income_md$name)

#-------------------household movers in South Australia----------------
movers <- income_md %>%
  filter(name == "Recent Movers Household Income") %>%
  get_data()


movers %>%
  mutate(Income = factor(Income, levels = c(
    "One or more incomes not stated",
    "Very low income", "Low income", "Moderate income", "High income"))) %>%
  rename(LGA = `LGA Name`) %>%
  filter(LGA != "South Australia") %>%
  ggplot(aes(weight = Households, fill = Income, x = LGA)) +
  geom_bar(position = "fill") +
  scale_fill_brewer() +
  coord_flip() +
  scale_y_continuous("Percentage of households in each category", label = percent) +
  labs(x = "Local Government Area") +
  ggtitle("Recent Movers' Household Income in South Australia",
          "Household income for households who had a different address in the 2011 Census compared to the 2006 Census")

