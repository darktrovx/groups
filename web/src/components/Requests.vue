<script>
    import NUI from './NUI.vue';
    import Button from './Button.vue';
    export default {
        components: {
            NUI,
            Button
        },
        name: 'Requests',
        data() { 
            return {
                Requests: [],
            } 
        },
        methods: {
            GetRequests: async function() {
                const requests = await NUI.methods.Callback("GetRequests")
                if (!requests) { return }
                this.Requests = requests
            },
            Accept: function(requestID) {
                NUI.methods.Callback("Accept", { requestID: requestID })
                this.GetRequests()
            },
            Deny: function(requestID) {
                NUI.methods.Callback("Deny", { requestID: requestID })
                this.GetRequests()
            },
        },
        mounted() {
            this.GetRequests()
        }
    };
</script>

<template>
    <div class="requests-container">
        <h2>Requests</h2>
        <div class="request-list">
            <div class="no-requests" v-show="this.Requests.length == 0">
                No Requests
            </div>

            <div class="request-item-container" v-show="this.Requests.length > 0">
                <div class="request-item" v-for="request in this.Requests">
                    <div class="request-item-name">{{ request.name }}</div>
                    
                    <div class="request-item-buttons">
                        <Button class="accept" icon="fa-solid fa-user-plus" toolTip="Accept Request" @click="Accept(request.id)"/>
                        <Button class="deny" icon="fa-solid fa-user-xmark" toolTip="Deny Request" @click="Deny(request.id)"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
    .requests-container {
        display: flex;
        flex-direction: column;
        gap: 1vh;
        height: 100%;
        overflow: hidden;
    }

    .request-list {
        height: 100%;
    }

    .no-requests {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100%;
    }

    .request-item-container {
        display: flex;
        flex-direction: column;
        gap: 1vh;
        height: 100%;
        overflow-y: auto;
    }
    
    .request-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.6vh 0.4vh;
        border-radius: 0.8vh;
        background-color: var(--secondaryDarkColor);
    }

    .request-item-name {
        min-width: 15vh;
    }

    .request-item-buttons {
        display: flex;
        flex-direction: row;
        gap: 0.4vh;
    }

    .accept {
        background-color: #99e2b465;
    }

    .deny {
        background-color: #ee6f6f65;
    }

    .accept:hover {
        background-color: #99e2b449;
    }

    .deny:hover {
        background-color: #ee6f6f48;
    }
</style>