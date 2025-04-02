<template>
  <div>
    {{ data?.greet }}
  </div>
</template>
<script setup lang="ts">
const route = useRoute()
const { data } = useFetch('/api/greet', { query: { name: route.query.name || 'world' } })
</script>
