for i in *
do
  tar -cf $i.tar $i
  xz $i.tar
  rm -rf $i
done
