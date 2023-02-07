|%
+$  records
  $:  watchlist=(map ship @dr)
      update-interval=@dr
  ==
+$  status
  $%  [%up =ship]
      [%down =ship]
  ==
+$  command
  $%  [%add-watch =ship t=@dr]
      [%del-watch =ship]
      [%set-update-interval t=@dr]
  ==
--
