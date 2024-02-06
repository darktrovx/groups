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
            const resp = await fetch(`https://${ resourceName }/${ eventName }`, options);
            resp.then((response) => {
              const jsonPromise = response.json();
              jsonPromise.then((data) => {
                return data;
              });
            });
          } catch(err) {
          }
        },
    }
  };
</script>