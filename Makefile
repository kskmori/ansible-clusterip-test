VIP=192.168.100.101
PORT=10007
RESPONSE=response.log

help:
	@echo "Cluster IP test scriptlets. Targets:"
	@echo "    make ping: start pinging to the hostname service on $(VIP):$(PORT)"
	@echo "    make stats: print the statistics of pinging results"

ping:
	while sleep 1 ; do timeout 2 bash -c "cat < /dev/tcp/$(VIP)/$(PORT)" || echo "T/O" ; done | tee $(RESPONSE)

stats:
	awk '{ num[$$1]++; } END { for (key in num) { print key ": " num[key] | "sort" }}' < $(RESPONSE)

### 
# perl version ; $ needs to be escaped for Makefile
#	perl -nle '$num{$_}++; END { foreach (sort(keys(%num))) {print "$_: $num{$_}"; }}' < $(RESPONSE)

clean:
	rm -f *.retry
	rm -f *~
	rm -f $(RESPONSE)
