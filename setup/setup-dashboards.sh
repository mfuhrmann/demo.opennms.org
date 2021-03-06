#!/bin/bash

GF_USER=admin
GF_PASS=secret
GF_URL=http://localhost:3000
GRAFANA_DATASOURCE="OpenNMS Horizon PM"
ds=(4033 4036 5053);

for d in "${ds[@]}"; do
  echo -n "Processing $d: "
  j=$(curl -s -k -u "${GF_USER}:${GF_PASS}" ${GF_URL}/api/gnet/dashboards/$d | jq .json)
  curl -s -k -u "${GF_USER}:${GF_PASS}" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{\"dashboard\":$j,\"overwrite\":true, \
        \"inputs\":[{\"name\":\"DS_OPENNMS_HORIZON PM\",\"type\":\"datasource\", \
        \"pluginId\":\"opennms-helm-performance-datasource\",\"value\":\"${GRAFANA_DATASOURCE}\"}]}" \
    ${GF_URL}/api/dashboards/import; echo ""
done
