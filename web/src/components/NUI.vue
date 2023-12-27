<script>
  export default {
    name: 'NUI',
    data() {},
    methods: {
        NUICallback: async function(eventName, data = {}) {
          const options = {
            method: "post",
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: JSON.stringify(data),
          };

          const resourceName = "devyn-groups";

          try {
            const resp = await fetch(`https://${resourceName}/${eventName}`, options);
            // resp.then((response) => {
            //   const jsonPromise = response.json();
            //   jsonPromise.then((data) => {
            //     return data;
            //   });
            // });
            return await resp.json();
          } catch(err) {
          }
        },
    }
  };
</script>