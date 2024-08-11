create index idx_review_profile on REVIEW_PROFILE (id_profile,id_score_name,id_score);
create index idx_tra_partition_genre on TRA_PARTITION_GENRE (id,genre); 
create index idx_profile_anime1 on PROFILE_ANIME (id);
create index idx_profile_anime2 on PROFILE_ANIME (anime_id,profile_id);
/