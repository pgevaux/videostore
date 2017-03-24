view: times_rented {
  derived_table: {
    persist_for: "24 hours"
    indexes: ["inventory_id"]
    sql: SELECT
        inventory.inventory_id  AS `inventory_id`,
        inventory.film_id  AS `film_id`,
        film.description AS film_name,
        store.store_id as store_id,
        COUNT(inventory.inventory_id) AS `rental.count`
      FROM sakila.rental  AS rental
      LEFT JOIN sakila.inventory  AS inventory ON rental.inventory_id = inventory.inventory_id
      LEFT JOIN sakila.film AS film ON inventory.film_id = film.film_id
      LEFT JOIN sakila.store AS store ON inventory.store_id = store.store_id
      GROUP BY 1,2
      ORDER BY COUNT(*) DESC
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: inventory_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension: film_id {
    type: number
    sql: ${TABLE}.film_id ;;
  }

  dimension: rental_count {
    type: number
    sql: ${TABLE}.`rental.count` ;;
  }

  dimension: film_title {
    type: string
    sql: ${TABLE}.film_name ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: should_be_retired {
    type: yesno
    sql: ${rental_count}>3 ;;
  }

  measure: total_times_rented {
    hidden: yes
    type: sum
    sql: ${rental_count} ;;
  }

  measure: inventory_item_count {
    type: count_distinct
    sql: ${inventory_id} ;;
    drill_fields: [detail*]
  }


  set: detail {
    fields: [inventory_id, film_id, film_title, store_id, rental_count]
  }
}
