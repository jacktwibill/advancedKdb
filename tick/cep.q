/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

if[not "w"=first string .z.o;system "sleep 1"];

upd:insert;

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

h(`.u.sub;`trade;`);
h(`.u.sub;`quote;`);

upd:{[t;data]
	id:first[(value flip data)[1]];
	if[t=`trade;
		t insert data;
		tmp:0!tradeAgg[id];
		aggTmp:flip[enlist each last[select from aggregation where sym=id]];
			if[not[(select from tmp)~(delete time,bap,bbp from aggTmp)];
				aggTmp:(.z.p;id;(first exec volume from tmp);(first exec minTp from tmp);(first exec maxTp from tmp);(first exec bap from tmp);(first exec bbp from tmp));
			]
	];
	if[t=`quote;
    t insert data;
    tmp:0!quoteAgg[id];
    aggTmp:flip[enlist each last[select from aggregation where sym=id]];
      if[not[(select from tmp)~(delete time,volume,minTp,maxTp from aggTmp)];
        aggTmp:(.z.p;id;(first exec volume from tmp);(first exec minTp from tmp);(first exec maxTp from tmp);(first exec bap from tmp);(first exec bbp from tmp));
      ]
  ];
	if[type[aggTmp]<>98h;`aggregation insert aggTmp;neg[h](`.u.upd;`aggregation;aggTmp)]
	}

tradeAgg:{[id]
	tradeStats:select volume:sum[ts],minTp:min[tp],maxTp:max[tp] by sym from trade where sym=id;
	tradeStats
	}

quoteAgg:{[id]
	quoteStats:select bap:min[ap],bbp:max[bp] by sym from quote where sym=id;
	quoteStats
	}
