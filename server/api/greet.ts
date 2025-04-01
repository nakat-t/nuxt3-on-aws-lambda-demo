import { H3Event } from 'h3'

export default defineEventHandler(async (event: H3Event) => {
    const query = getQuery(event)

    return {
        greet: `Hello, ${query.name || 'world'}!`,
    }
})
