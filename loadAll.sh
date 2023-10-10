start_range=0
clk=0
start_time=$(date +%s.%N)

if [ "$#" -eq 1 ]; then
	end_range="$1"
	clk=6000000
elif [ "$#" -eq 2 ]; then
	end_range="$1"
	clk="$2"
	clk=$((clk * 1000000))
else
	echo "Using ./loadAll FPGA_Index_End clk_MHz"
	exit 0
fi

for i in $(seq "$start_range" "$end_range")
do
	echo "----Load bit for FPGA $i with clk $clk"
	if [ "$i" -lt "$end_range" ]; then
    	./openFPGALoader -c ft4232 --cable-index $i -v --freq $clk > /tmp/log 2>&1 &
	else
		./openFPGALoader -c ft4232 --cable-index $i -v --freq $clk > /tmp/log
	fi

done

end_time=$(date +%s.%N)
running_time=$(echo "$end_time - $start_time" | bc)
echo "Load bitstream time: $running_time seconds"