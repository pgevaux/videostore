view: city {
  sql_table_name: sakila.city ;;

  dimension: city_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.city_id ;;
  }

  dimension: city {
    view_label: "Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.country_id ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  measure: count {
    type: count
    drill_fields: [city_id, country.country_id, address.count]
  }
}
