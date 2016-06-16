# copy analysis results from yisib

# Constant
raw_path=/data/home/yisib/Project_DefaultProject
target_path=/data/home/lijiaj/data/yisibProject

# Main
cd $raw_path
for i in *
do
  if [[ $i == Sample* ]]; then
    continue
  fi
  mkdir -p $target_path/$i
  cp $i/04-rsem-expression/*.results $target_path/$i
  cp -r $i/04-rsem-expression/*.stat $target_path/$i
done
