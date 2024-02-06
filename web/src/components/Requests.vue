<script>
    import NUI from './NUI.vue';
    export default {
        comonents: {
            NUI,
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
        <div class="request-list">
            <div class="no-requests" v-show="this.Requests.length == 0">
                No Requests
            </div>
            <div class="request-item" v-for="request in this.Requests">
                <div class="request-item-name">{{ request.name }}</div>
                <div class="request-item-buttons">
                    <div class="request-item-button request-item-accept" @click="Accept(request.id)"><span><i class="fa-solid fa-user-plus"></i></span></div>
                    <div class="request-item-button request-item-deny" @click="Deny(request.id)"><span><i class="fa-solid fa-user-xmark"></i></span></div>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
    .requests-container {
        margin-top: 7vh;
    }

    .request-list {
        min-width: 40vh;
        max-width: 40vh;
        min-height: 35vh;
        max-height: 45vh;
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        padding-top: 3vh;
        -webkit-scrollbar: none;
    }

    .no-requests {
        font-size: 2vh;
    }

    .request-item {
        display: flex;
        flex-direction: row;
        margin-bottom: 2vh;
        border-bottom: 1px solid #6c757d;
        padding-bottom: 5px;
    }

    .request-item-name {
        min-width: 15vh;
    }

    .request-item-buttons {
        margin-left: 15vh;
        float: right;
        display: flex;
        flex-direction: row;
    }

    .request-item-button {
        margin-right: 2vh;
    }

    .request-item-accept:hover {
        color: #b9fbc0;
        cursor: pointer;
    }

    .request-item-deny:hover {
        color: #e63946;
        cursor: pointer;
    }    
</style>