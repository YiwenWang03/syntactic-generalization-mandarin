library(data.table)
library(dplyr)
library(tidyr)
library(magrittr)
library(stringr)
require(lme4)

# modifier types
mod_type <- function(a) {
  if (a["none"] == "1"){
    return("none")
  } 
  if (a["adj"] == "1"){
    return("adj")
  } 
  if (a["obj"] == "1"){
    return("obj")
  } 
  if (a["sub"] == "1"){
    return("sub")
  } 
}

mod_type_mobj <- function(a){
  if (a["none"] == "1"){
    return("none")
  } 
  if (a["sub"] == "1"){
    return("sub")
  } 
  if (a["sub2"] == "1"){
    return("sub2")
  } 
  if (a["subh"] == "1"){
    return("subh")
  } 
}

print_p <- function(lmer_result){
  coefs <- data.frame(coef(summary(lmer_result)))
  # use normal distribution to approximate p-value
  coefs$p.z <- 2 * (1 - pnorm(abs(coefs$t.value)))
  print(coefs)
}

# Subordination + random slope
subordination_df <- read.table("subordination.csv",header=TRUE,sep=",",stringsAsFactors = F)
subordination <- lmer(accuracy ~ model + (1 + model| modifier) + 
                        (1 + model| seed), data = subordination_df)
summary(subordination)
print_p(subordination)


# Syntactic v.s. Semantic + random slope
# syn_sem_ave
syn_sem_ave_df <- read.table("syn_sem_ave.csv",header=TRUE,sep=",",stringsAsFactors = F)
syn_sem_ave <- lmer(accuracy ~ syn + (1 + syn| modifier) + (1 + syn|model) +
                      (1 +syn| seed), data = syn_sem_ave_df)
summary(syn_sem_ave)
print_p(syn_sem_ave)
# brm MAP p-value: 0

# syn_sem_no_modifier
syn_sem_no_df <- read.table("syn_sem_no.csv",header=TRUE,sep=",",stringsAsFactors = F)
syn_sem_no <- lmer(accuracy ~ syn + (1+syn|model) +
                     (1 +syn| seed), data = syn_sem_no_df)
summary(syn_sem_no)
print_p(syn_sem_no)


# Missing Object: robustness against intervening contents
mobj_df <- read.table("Missing_Object.csv",header=TRUE,sep=",",stringsAsFactors = F)
# lstm
mobj_lstm_df <- mobj_df[mobj_df$model=='LSTM',]
mobj_lstm <- lmer(accuracy ~ modifier  + 
                    (1+modifier| seed) + (1+modifier|data), data = mobj_lstm_df)
summary(mobj_lstm)
print_p(mobj_lstm)

# rnng
mobj_rnng_df <- mobj_df[mobj_df$model=='RNNG',]
mobj_rnng <- lmer(accuracy ~ modifier  + 
                    (1+modifier| seed) + (1+modifier|data), data = mobj_rnng_df)
summary(mobj_rnng)
print_p(mobj_rnng)

# transformer
mobj_trans_df <- mobj_df[mobj_df$model=='Transformer',]
mobj_trans <- lmer(accuracy ~ modifier  + 
                     (1+modifier| seed) + (1+modifier|data), data = mobj_trans_df)
summary(mobj_trans)
print_p(mobj_trans)

# plm
mobj_plm_df <- mobj_df[mobj_df$model=='PLM',]
mobj_plm <- lmer(accuracy ~ modifier  + 
                   (1+modifier| seed) + (1+modifier|data), data = mobj_plm_df)
summary(mobj_plm)
print_p(mobj_plm)


# Data Size
data_size_df <- read.table("data_size_df.csv",header=TRUE,sep=",",stringsAsFactors = F)
# lstm
ds_lstm_df <- data_size_df[data_size_df$model=='LSTM',]
ds_lstm <- lmer(accuracy ~ large  + (1+large|class) + (1+large|modifier) +
                  (1+large| seed), data = ds_lstm_df)
summary(ds_lstm)
print_p(ds_lstm)

# rnng
ds_rnng_df <- data_size_df[data_size_df$model=='RNNG',]
ds_rnng <- lmer(accuracy ~ large  + (1+large|class) + (1+large|modifier) +
                  (1+large| seed), data = ds_rnng_df)
summary(ds_rnng)
print_p(ds_rnng)


# transformer
ds_trans_df <- data_size_df[data_size_df$model=='Transformer',]
ds_trans <- lmer(accuracy ~ large  + (1+large|class) + (1+large|modifier) +
                   (1+large| seed), data = ds_trans_df)
summary(ds_trans)
print_p(ds_trans)


# plm
ds_plm_df <- data_size_df[data_size_df$model=='PLM',]
ds_plm <- lmer(accuracy ~ large  + (1+large|class) + (1+large|modifier) +
                 (1+large| seed), data = ds_plm_df)
summary(ds_plm)
print_p(ds_plm)


##  Table 1 modifier as random factor (intercept)
cls <- read.table("lr_Classifier.csv",header=TRUE,sep=",",stringsAsFactors = F)
cls$modifier <- apply(cls,1,mod_type)
cls_small_lstm <- cls[cls$lstm == "True" & cls$data == "True",]
cls_small_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                            (1 | seed), data = cls_small_lstm, family = binomial)
summary(cls_small_lstm_m)
cls_large_lstm <- cls[cls$lstm == "True" & cls$data == "False",]
cls_large_lstm_m <- glmer(outcome ~ syntax +  (1|modifier)  + (1 | item) + 
                            (1 | seed), data = cls_large_lstm, family = binomial)
summary(cls_large_lstm_m)
cls_small_transformer <- cls[cls$lstm == "False" & cls$data == "True",]
cls_small_transformer_m <- glmer(outcome ~ syntax  + (1|modifier)  + (1 | item) + 
                                   (1 | seed), data = cls_small_transformer, family = binomial)
summary(cls_small_transformer_m)
cls_large_transformer <- cls[cls$lstm == "False" & cls$data == "False",]
cls_large_transformer_m <- glmer(outcome ~ syntax  + (1|modifier) + (1 | item) + 
                                   (1 | seed), data = cls_large_transformer, family = binomial)
summary(cls_large_transformer_m)


gpo<- read.table("lr_GP_obj.csv",header=TRUE,sep=",",stringsAsFactors = F)
gpo$modifier <- apply(gpo,1,mod_type)
gpo_small_lstm <- gpo[gpo$lstm == "True" & gpo$data == "True",]
gpo_small_lstm_m <- glmer(outcome ~ syntax +(1|modifier)  + (1 | item) + 
                            (1 | seed), data = gpo_small_lstm, family = binomial)
summary(gpo_small_lstm_m)
gpo_large_lstm <- gpo[gpo$lstm == "True" & gpo$data == "False",]
gpo_large_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                            (1 | seed), data = gpo_large_lstm, family = binomial)
summary(gpo_large_lstm_m)
gpo_small_transformer <- gpo[gpo $lstm == "False" & gpo$data == "True",]
gpo_small_transformer_m <- glmer(outcome ~ syntax + (1|modifier)  + (1 | item) + 
                                   (1 | seed), data = gpo_small_transformer, family = binomial)
summary(gpo_small_transformer_m)
gpo_large_transformer <- gpo[gpo$lstm == "False" & gpo$data == "False",]
gpo_large_transformer_m <- glmer(outcome ~ syntax + (1|modifier)  + (1 | item) + 
                                   (1 | seed), data = gpo_large_transformer, family = binomial)
summary(gpo_large_transformer_m)


gps <- read.table("lr_GP_sub.csv",header=TRUE,sep=",",stringsAsFactors = F)
gps$modifier <- apply(gps,1,mod_type)
gps_small_lstm <- gps[gps$lstm == "True" & gps$data == "True",]
gps_small_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                            (1 | seed), data = gps_small_lstm, family = binomial)
summary(gps_small_lstm_m)
gps_large_lstm <- gps[gps$lstm == "True" & gps$data == "False",]
gps_large_lstm_m <- glmer(outcome ~ syntax + (1|modifier)+ (1 | item) + 
                            (1 | seed), data = gps_large_lstm, family = binomial)
summary(gps_large_lstm_m)
gps_small_transformer <- gps[gps$lstm == "False" & gps$data == "True",]
gps_small_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                   (1 | seed), data = gps_small_transformer, family = binomial)
summary(gps_small_transformer_m)
gps_large_transformer <- gps[gps$lstm == "False" & gps$data == "False",]
gps_large_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                   (1 | seed), data = gps_large_transformer, family = binomial)
summary(gps_large_transformer_m)

vn <- read.table("lr_Verb_Noun.csv",header=TRUE,sep=",",stringsAsFactors = F)
vn$modifier <- apply(vn,1,mod_type)
vn_small_lstm <- vn[vn$lstm == "True" & vn$data == "True",]
vn_small_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                           (1 | seed), data = vn_small_lstm, family = binomial)
summary(vn_small_lstm_m)
vn_large_lstm <- vn[vn$lstm == "True" & vn$data == "False",]
vn_large_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                           (1 | seed), data = vn_large_lstm, family = binomial)
summary(vn_large_lstm_m)
vn_small_transformer <- vn[vn$lstm == "False" & vn$data == "True",]
vn_small_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                  (1 | seed), data = vn_small_transformer, family = binomial)
summary(vn_small_transformer_m)
vn_large_transformer <- vn[vn$lstm == "False" & vn$data == "False",]
vn_large_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                  (1 | seed), data = vn_large_transformer, family = binomial)
summary(vn_large_transformer_m)


mobj <- read.table("lr_Missing_Object.csv",header=TRUE,sep=",",stringsAsFactors = F)
mobj$modifier <- apply(mobj,1,mod_type_mobj)
mobj_small_lstm <- mobj[mobj$lstm == "True" & mobj$data == "True",]
mobj_small_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                             (1 | seed), data = mobj_small_lstm, family = binomial)
summary(mobj_small_lstm_m)
mobj_large_lstm <- mobj[mobj$lstm == "True" & mobj$data == "False",]
mobj_large_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                             (1 | seed), data = mobj_large_lstm, family = binomial)
summary(mobj_large_lstm_m)
mobj_small_transformer <- mobj[mobj$lstm == "False" & mobj$data == "True",]
mobj_small_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                    (1 | seed), data = mobj_small_transformer, family = binomial)
summary(mobj_small_transformer_m)
mobj_large_transformer <- mobj[mobj$lstm == "False" & mobj$data == "False",]
mobj_large_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                    (1 | seed), data = mobj_large_transformer, family = binomial)
summary(mobj_large_transformer_m)


subn <- read.table("lr_Subordination.csv",header=TRUE,sep=",",stringsAsFactors = F)
subn$modifier <- apply(subn,1,mod_type)
subn_small_lstm <- subn[subn$lstm == "True" & subn$data == "True",]
subn_small_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                             (1 | seed), data = subn_small_lstm, family = binomial)
summary(subn_small_lstm_m)
subn_large_lstm <- subn[subn$lstm == "True" & subn$data == "False",]
subn_large_lstm_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                             (1 | seed), data = subn_large_lstm, family = binomial)
summary(subn_large_lstm_m)
subn_small_transformer <- subn[subn$lstm == "False" & subn$data == "True",]
subn_small_transformer_m <- glmer(outcome ~ syntax + (1|modifier) + (1 | item) + 
                                    (1 | seed), data = subn_small_transformer, family = binomial)
summary(subn_small_transformer_m)
subn_large_transformer <- subn[subn$lstm == "False" & subn$data == "False",]
subn_large_transformer_m <- glmer(outcome ~ syntax + (1|modifier)+ (1 | item) + 
                                    (1 | seed), data = subn_large_transformer, family = binomial)
summary(subn_large_transformer_m)

