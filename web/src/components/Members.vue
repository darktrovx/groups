<script>
    import NUI from './NUI.vue';
    export default {
        comonents: {
            NUI,
        },
        name: 'Members',
        data() { 
            return {
                Members: [],
            }
        },
        methods: {
            GetMembers: async function() {
                const members = await NUI.methods.NUICallback("GetMembers")
                if (!members) { return }
                this.Members = members
            },
            Kick: function(id) {
                NUI.methods.NUICallback("Kick", { id: id })
                this.GetMembers()
            },
        },
        mounted() {
            this.GetMembers()
        }
    };
</script>

<template>
    <div class="members-container">
        <div class="members-list">
            <div class="members-item" v-for="member in this.Members">
                <div class="members-item-name"> {{ member.name }}</div>
                <div class="members-item-buttons">
                    <div class="members-item-kick" @click="Kick(member.id)" v-show="!member.owner"><span><i class="fa-solid fa-user-slash"></i></span></div>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
    .members-container {
        margin-top: 7vh;
    }

    .members-list {
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

    .members-item {
        display: flex;
        flex-direction: row;
        margin-bottom: 2vh;
        border-bottom: 1px solid #6c757d;
        padding-bottom: 5px;
    }

    .members-item-name {
        min-width: 15vh;
    }

    .members-item-buttons {
        margin-left: 15vh;
        float: right;
        display: flex;
        flex-direction: row;
    }

    .members-item-kick:hover {
        color: #e63946;
        cursor: pointer;
    }    
</style>