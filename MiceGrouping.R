optimize_groups_AC<-function(data,variables,nk,sample_label=NA)
{
  # data: dataset with variables
  # variables: variables of interest, anti-clustering is performed with those
  # nk: vector with size of each group
  # sample_label: column with sample names in the dataset (optional)
  
  library(tidyverse)
  library(anticlust)
  library(ggrepel)
  library(RColorBrewer)
  
  #print summary of variables of interest
  for (v in variables)
  {
  print(paste("Distribution of ",v))
  print(summary(data[[v]]))
  }
  
  #check if a grouping remains from previous steps
  data <- data %>% 
    ungroup()
  
  #plot distribution for variables of interest
    
  data_plot <- data %>% 
      select(all_of(variables)) %>%
      gather("variable","value")
  
   print(ggplot(data_plot , aes(1, value)) +
           geom_violin(trim=FALSE)+
           geom_boxplot(fill="grey", alpha=0.8) +
      #geom_violin(width=1.4,trim=FALSE,aes(fill=variable)) +
     
      #scale_fill_brewer(palette = "Set1") +
      facet_wrap(~variable,scales="free_y")+
      labs(x=NULL,title="Variables distribution")+
      guides(fill=FALSE)+
    theme_classic(base_size=20)+
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank())
    )
  
  # anti-clustering analysis on the variables of interest 
  anticlust <- anticlustering(
    data[,variables],
    K = nk,
    objective = "diversity",
    method = "local-maximum",
    repetitions = 10,
    standardize = TRUE
  )
  
  #create new columns with optimized groups
  data_final<-data %>% 
    mutate(Opt_groups=anticlust)
  
  ncounts<-data_final %>% group_by(Opt_groups) %>% summarize(n=n())
  
  labsx<-paste(ncounts$Opt_groups,"\n n=",ncounts$n)
  
  # plot distribution for variables of interest in the optimized groups
  for (v in variables)
  {
    data_final$var<-data[[v]]
    
    p<-data_final %>% ggplot() +
      geom_boxplot(aes(x=as.factor(Opt_groups),y=var))+
      #geom_label_repel(aes(x=as.factor(Opt_groups),y=var,label=sample),force=1.3,color="red")+
      labs(x="Optimized groups",y=v,title=paste("Final grouping, variable:",v))+
      scale_x_discrete(labels=labsx)+
      theme_classic(base_size=20)
    
    if (is.na(sample_label)==FALSE)
    {
      data_final$sample<-data[[sample_label]]
      
      p<-p+
        geom_label_repel(data=data_final,aes(x=as.factor(Opt_groups),y=var,label=sample),force=1.3,color="red")
    
      data_final<-data_final %>% 
        select(-sample)
      }
    
    print(p)
  }
  
  # plot sample groups in the space of the variables of interest
  print(plot_clusters(data_final[,variables],clusters=data_final$Opt_groups,show_axes = TRUE))
  
  data_final<-data_final %>% 
    select(-var) 
  
  return(data_final)
  
}