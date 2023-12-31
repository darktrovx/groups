<script>

  import NUI from './components/NUI.vue';
  import Group from './components/Group.vue';

  export default {
    components: {
      NUI,
      Group
    },
    data() {
        return {
            Display: false,
            InGroup: false,
            Owner: false,
            Members: [],
            Groups: [],
            Requests: [],
        }
    },
    methods: {
        Open: function() {
            this.Display = true;
        },
        Close: function() {
            this.Display = false;
            NUI.methods.NUICallback("close")
        },
        JoinGroup: async function(id) {
            const cb = await NUI.methods.NUICallback("JoinGroup", { groupID: id })
            if (!cb) { return }
        },
        Create: async function() {
            const cb = await NUI.methods.NUICallback("CreateGroup")
            if (!cb) { return }
            setTimeout(() => {
                this.InGroup = true;
                this.Owner = true;
            }, 300);
        },
        Leave: async function() {
            const cb = await NUI.methods.NUICallback("LeaveGroup")
            if (!cb) { return }
            this.Cleanup()
        },
        Cleanup: function() {
            this.InGroup = false;
            this.Owner = false;
            this.Members = [];
        },
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            switch(event.data.type) {
                case "open":
                    this.Open()
                    break;
                case "close":
                    this.Close()
                    break;
                case "updateGroups":
                    this.Groups = event.data.groups
                    break;
            }
        });

        this.listener = window.addEventListener("keyup", (event) => {
            if (event.key == 'Escape') {
                this.Close()
            }
        });
    },
}
</script>

<template>

  <div class="ui-wrapper" v-show="this.Display">
    <div class="group-container" v-show="this.Display">
        <div class="group-header">
            <div class="group-title" v-show="!this.InGroup">
                Available Groups
            </div>
            <div class="group-btns">
                <span class="group-create" v-show="!this.InGroup" @click="Create"><i class="fa-solid fa-plus"></i></span>
                <span class="group-leave" v-show="this.InGroup" @click="Leave"><i class="fa-solid fa-arrow-right-from-bracket"></i></span>
            </div>
            <div class="group-close" @click="Close">
                <span><i class="fa-solid fa-xmark"></i></span>
            </div>
        </div>
        <div class="groups-list" v-show="!this.InGroup">
            <div class="no-group-available" v-show="this.Groups.length == 0">
                No Groups Available
            </div>
            <div class="group-available" v-for="group in this.Groups">
                <div class="group-available-name">
                    {{ group.name }}
                </div>
                <div class="group-member-count">
                    <div> <span><i class="fa-solid fa-user-group"></i></span> x{{ group.members }}</div>
                </div>
                <div class="group-available-join" @click="JoinGroup(group.id)">
                    <span><i class="fa-solid fa-arrow-right-to-bracket"></i></span>
                </div>
            </div>
        </div>
        <div v-show="this.InGroup">
            <Group :Members="this.Members" :Owner="this.Owner"/>
        </div>
    </div>
  </div>

</template>

<style>
    .ui-wrapper {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: transparent;
        color: white !important;
    }

    .group-container {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 40vh;
        height: 60vh;
        background: rgb(33,37,41);
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        display: flex;
    }

    .group-header {
        text-align: center;
        display: flex;
        max-height: 7vh;
    }

    .group-title {
        margin-top: 3vh;
        margin-left: 13vh;
        font-size: 2vh;
    }

    .group-btns {
        margin-top: 1vh;
        position: absolute;
        left: 1vh;
        float: right;
        background-color: transparent;
    }

    .group-create:hover {
        color:#b9fbc0;
        cursor: pointer;
    }

    .group-leave:hover {
        color:#e63946;
        cursor: pointer;
    }

    .group-close {
        margin-top: 1vh;
        position: absolute;
        right: 1vh;
        float: right;
        background-color: transparent;
    }

    .group-close:hover {
        color:#e63946;
        cursor: pointer;
    }

    .groups-list {
        width: 100%;
        height: 100%;
        overflow-y: hidden;
        margin-top: 10vh;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        padding: 10px;
    }

    .no-group-available {
        margin-left: 11vh;
        font-size: 2vh;
    }

    .group-available {
        display: flex;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        margin-top: 2vh;
        padding-bottom: 1vh;
    }

    .group-available-name {
        margin-left: 2vh;
        font-size: 2vh;
    }

    .group-member-count {
        margin-left: 10vh;
        text-align: center;
    }

    .group-available-join {
        position: absolute;
        right: 2vh;
        float: right;
    }

    .group-available-join:hover {
        color: #b9fbc0;
        cursor: pointer;
    }

</style>