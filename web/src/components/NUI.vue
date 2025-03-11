<script>
    export default {
        name: 'NUI',
        data() {
            return {
                resourceName: "groups",
            }
        },
        methods: {
            Callback: async function(eventName, data = {}) {
                const options = {
                    method: "post",
                    headers: {
                        "Content-Type": "application/json; charset=UTF-8",
                    },
                    body: JSON.stringify(data),
                };

                const resourceName = 'groups';
                try {
                    const response = await fetch(`https://${resourceName}/${eventName}`, options);
                    const responseData = await response.json();
                    return responseData;
                } catch (err) {
                    console.error("Error in Callback:", err);
                    throw err;
                }
            },
        }
    };
</script>