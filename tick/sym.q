/msgCount::0;
trade:([]time:`timestamp$();sym:`symbol$();exchange:`symbol$();ticker:`symbol$();tp:`float$();ts:`int$());
quote:([]time:`timestamp$();sym:`symbol$();exchange:`symbol$();ticker:`symbol$();ap:`float$();as:`int$();bp:`float$();bs:`int$());
aggregation:([]time:`timestamp$();sym:`symbol$();minPrice:`float$();maxPrice:`float$();volume:`long$());
/\t 60000
/.z.ts:{-1"The tickerplant recieved ",string[msgCount]," messages this messages";{-1"The following subscription was added this minute ",x}each newSubs;}
